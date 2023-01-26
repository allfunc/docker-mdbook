#!/usr/bin/env sh
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

TERRATEST=$(${DIR}/../support/TERRATEST.sh)

docker run --rm -v $DIR/../:/app/test \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /app/test \
  $TERRATEST \
  go test -v ./tests


