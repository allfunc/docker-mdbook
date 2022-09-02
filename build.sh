#!/usr/bin/env bash

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

FOLDER_PREFIX=$(${DIR}/support/FOLDER_PREFIX.sh)
COPY_FILES=$(${DIR}/support/COPY_FILES.sh)
DOCKER_FILES=$(${DIR}/support/DOCKER_FILES.sh)
BUILD_VERSION=$1

if [ -z "$BUILD_VERSION" ]; then
  echo "Not set build version."
  exit 1
fi

do_build() {
  echo 'building --- Version: ' $BUILD_VERSION '-->'
  DEST_FOLDER=${DIR}/${FOLDER_PREFIX}${BUILD_VERSION}
  mkdir -p ${DEST_FOLDER}

  for file in $COPY_FILES; do [ -e "$file" ] && cp -a $file ${DEST_FOLDER}; done
  for file in $DOCKER_FILES; do
    if [ -e "$file" ]; then
      cp $file ${DEST_FOLDER}
      DEST_FILE=${DEST_FOLDER}/$file
      sed -i -e "s|\[VERSION\]|$BUILD_VERSION|g" ${DEST_FILE}
      if [ -e "${DEST_FILE}-e" ]; then rm ${DEST_FILE}-e; fi
    fi
  done
}

do_build
