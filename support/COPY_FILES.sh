#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV=${DIR}/../.env.build

if [ -z "$COPY_FILES" ]; then
  COPY_FILES=$(awk -F "=" '/^COPY_FILES\[\]/ {print $2}' $ENV)
fi

echo $COPY_FILES
