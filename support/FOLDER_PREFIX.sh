#!/bin/bash
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV=${DIR}/../.env.build

if [ -z $FOLDER_PREFIX ]; then
  FOLDER_PREFIX=$(awk -F "=" '/^FOLDER_PREFIX/ {print $2}' $ENV)
fi

echo $FOLDER_PREFIX
