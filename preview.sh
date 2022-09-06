#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
ENV="${DIR}/.env"

if [ -e "${ENV}" ]; then
  MDBOOK_SRC=$(awk -F "=" '/^MDBOOK_SRC/ {print $2}' $ENV)
  if [ ! -z "${MDBOOK_SRC}" ]; then
    MDBOOK_SRC=$DIR/$MDBOOK_SRC
  fi
  CONTAINER_NAME=$(awk -F "=" '/^CONTAINER_NAME/ {print $2}' $ENV)
  PORT=$(awk -F "=" '/^PORT/ {print $2}' $ENV)
fi

MDBOOK_SRC=${MDBOOK_SRC:-$DIR}
CONTAINER_NAME=${CONTAINER_NAME:-mdbook}
PORT=${PORT:-3888}

# echo $MDBOOK_SRC
# echo $CONTAINER_NAME
# echo $PORT
# exit;

OpenCmd=$(which xdg-open 2>/dev/null)
case "$OSTYPE" in
  linux*)
    if [ -z "$OpenCmd" ]; then 
      OpenCmd="echo" 
    fi
    ;;
  darwin*)
    OpenCmd="open" 
    ;;
  *)
    if [ -z "$OpenCmd" ]; then 
      OpenCmd="echo" 
    fi
    ;;
esac

start() {
  stop
  cmd="docker run -p ${PORT}:3000";
  if [ -e "${DIR}/book.toml" ]; then
    cmd+=" -v ${DIR}/book.toml:/mdbook/book.toml";
  fi
  cmd+=" -v ${MDBOOK_SRC}:/mdbook/src --name ${CONTAINER_NAME} --rm -d hillliu/mdbook serve -n 0.0.0.0";
  echo $cmd;
  echo $cmd | bash
  sleep 5 
  echo ${OpenCmd} http://localhost:${PORT} | bash
  logs
}

build() {
  cmd="docker run";
  if [ -e "${DIR}/book.toml" ]; then
    cmd+=" -v ${DIR}/book.toml:/mdbook/book.toml";
  fi
  cmd+=" -v ${MDBOOK_SRC}:/mdbook/src --rm -d hillliu/mdbook build -d /mdbook/src/dist";
  echo $cmd;
  echo $cmd | bash
}

stop() {
  local res=$(status | tail -1 | awk '{print $(NF)}')
  if [ "x$res" == "x$CONTAINER_NAME" ]; then
    docker stop ${CONTAINER_NAME}
  fi
#  docker stop ${CONTAINER_NAME}
#  docker rm ${CONTAINER_NAME}
}

status() {
  docker ps -f name=${CONTAINER_NAME}
}

logs() {
  docker logs -f ${CONTAINER_NAME}
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  build)
    build
    ;;
  status)
    status
    ;;
  logs)
    logs
    ;;
  *)
    echo "$0 [start|stop|build|status|logs]"
    exit
esac

exit $?
