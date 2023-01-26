#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

ENV=${DIR}/../.env.build

if [ -z "$localImage" ]; then
  localImage=$(awk -F "=" '/^localImage/ {print $2}' $ENV)
fi

echo $localImage
