#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

if [ -z $sourceImage ]; then
sourceImage=$(awk -F "=" '/^sourceImage/ {print $2}' ${DIR}/.env)
fi

echo $sourceImage
