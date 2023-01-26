#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV=${DIR}/../.env.build

if [ -z "$DOCKER_FILES" ]; then
  DOCKER_FILES=$(awk -F "=" '/^DOCKER_FILES\[\]/ {print $2}' $ENV)
fi

echo $DOCKER_FILES
