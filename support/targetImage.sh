#!/bin/bash
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV=${DIR}/../.env.build

if [ -z $targetImage ]; then
  targetImage=$(awk -F "=" '/^targetImage/ {print $2}' $ENV)
fi

echo $targetImage
