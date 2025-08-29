#!/usr/bin/env sh

# Init workdir
echo $(date +%Y%m%d%S)'-'$TARGETPLATFORM > /build_version
mv /entrypoint /entrypoint-plantuml
mkdir -p /mdbook/src
chmod 0777 -R /mdbook
chmod 0777 -R /var/cache/fontconfig

##
# fixed mdbook-plantuml runtime need libssl.so.1.1
# https://github.com/allfunc/docker-mdbook/issues/8
##
cd /tmp && wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb && dpkg -i *.deb
apt-get update && apt-get --yes install pandoc

# Clean
apt-get clean autoclean \
  && apt-get autoremove --yes \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf rm -rf /opt/rust/cargo/registry/* \
  && rm -rf /tmp/* || exit 1

exit 0
