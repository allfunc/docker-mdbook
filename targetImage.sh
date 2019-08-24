#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

if [ -z $targetImage ]; then
targetImage=$(awk -F "=" '/^targetImage/ {print $2}' ${DIR}/.env)
fi

echo $targetImage
