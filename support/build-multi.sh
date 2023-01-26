#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

FOLDER_PREFIX=$(${DIR}/VER_PREFIX.sh)
COPY_FILES=$(${DIR}/COPY_FILES.sh)
DOCKER_FILES=$(${DIR}/DOCKER_FILES.sh)
BUILD_VERSION=$1

if [ -z "$BUILD_VERSION" ]; then
  echo "Not set build version."
  exit 1
fi

do_build() {
  echo 'building --- Version: ' $BUILD_VERSION '-->'
  BUILD_FOLDER=${DIR}/../${FOLDER_PREFIX}-${BUILD_VERSION}
  mkdir -p ${BUILD_FOLDER}

  for file in $COPY_FILES; do [ -e "$file" ] && cp -a $file ${BUILD_FOLDER}; done
  for file in $DOCKER_FILES; do
    if [ -e "$file" ]; then
      cp $file ${BUILD_FOLDER}
      DEST_FILE=${BUILD_FOLDER}/$file
      sed -i -e "s|\[VERSION\]|$BUILD_VERSION|g" ${DEST_FILE}
      if [ -e "${DEST_FILE}-e" ]; then rm ${DEST_FILE}-e; fi
    fi
  done
}

do_build
