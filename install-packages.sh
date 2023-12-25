#!/usr/bin/env sh

###
# Environment ${INSTALL_VERSION} pass from Dockerfile
###

INSTALL=""

BUILD_DEPS=""

echo "###"
echo "# Will install"
echo "###"
echo ""
echo $INSTALL
echo ""
echo "###"
echo "# Will install build tool"
echo "###"
echo ""
echo $BUILD_DEPS
echo ""

apk add --virtual .build-deps $BUILD_DEPS && apk add $INSTALL

#/* put your install code here */#

# install libssl dev
cd /tmp && wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb && dpkg -i *.deb

# Init workdir
mv /entrypoint /entrypoint-plantuml
mkdir -p /mdbook/src
chmod 0777 -R /mdbook
chmod 0777 -R /var/cache/fontconfig

echo $(date +%Y%m%d%S)'-'$TARGETPLATFORM > /build_version

# Clean
apt-get clean autoclean \
  && apt-get autoremove --yes \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf rm -rf /opt/rust/cargo/registry/* \
  && rm -rf /tmp/* || exit 1

exit 0
