#!/usr/bin/env sh

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
