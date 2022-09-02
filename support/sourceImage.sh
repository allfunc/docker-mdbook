#!/bin/bash
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV=${DIR}/../.env.build

if [ -z $sourceImage ]; then
  sourceImage=$(awk -F "=" '/^sourceImage/ {print $2}' $ENV)
fi

echo $sourceImage
