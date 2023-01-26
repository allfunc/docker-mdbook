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
mv /entrypoint /entrypoint-plantuml

apk del -f .build-deps && rm -rf /var/cache/apk/* || exit 1

exit 0
