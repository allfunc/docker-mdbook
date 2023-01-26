#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

ENV=${DIR}/../.env.build

if [ -z "$TERRATEST" ]; then
  TERRATEST=$(awk -F "=" '/^TERRATEST/ {print $2}' $ENV)
fi

echo $TERRATEST
