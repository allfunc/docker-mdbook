#!/usr/bin/env sh
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

if [ -z $ALT_VERSION ]; then
  ALT_VERSION=$(awk -F "=" '/^ALT_VERSION/ {print $2}' ${DIR}/../.env.build)
fi

echo $ALT_VERSION
