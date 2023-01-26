#!/usr/bin/env sh

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

ENV=${DIR}/../.env.build

if [ -z $VERSION ]; then
  VERSION=$(awk -F "=" '/^VERSION/ {print $2}' $ENV)
fi

echo $VERSION
