#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

ENV=${DIR}/../.env.build

if [ -z "$VER_PREFIX" ]; then
  VER_PREFIX=$(awk -F "=" '/^VER_PREFIX/ {print $2}' $ENV)
fi

echo $VER_PREFIX
