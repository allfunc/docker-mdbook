#!/usr/bin/env sh

DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV="${DIR}/.env"
IMAGE_NAME="hillliu/mdbook"

if [ -e "${ENV}" ]; then
  MDBOOK_SRC=$(awk -F "=" '/^MDBOOK_SRC/ {print $2}' $ENV)
  if [ ! -z "${MDBOOK_SRC}" ]; then
    MDBOOK_SRC=$DIR/$MDBOOK_SRC
  fi
  CONTAINER_NAME=$(awk -F "=" '/^CONTAINER_NAME/ {print $2}' $ENV)
  ENV_PORT=$(awk -F "=" '/^PORT/ {print $2}' $ENV)
  if [ ! -z "${ENV_PORT}" ]; then
    PORT=$ENV_PORT
  fi
fi

MDBOOK_SRC=${MDBOOK_SRC:-$DIR}
CONTAINER_NAME=${CONTAINER_NAME:-mdbook}

OpenCmd=$(which xdg-open 2> /dev/null)
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
  PORT=${PORT:-3888}
  # echo $MDBOOK_SRC
  # echo $CONTAINER_NAME
  # echo $PORT
  # exit;
  stop
  cmd="docker run -p ${PORT}:${PORT} -e PORT=${PORT} -u $(id -u):$(id -g)"
  if [ -e "${DIR}/book.toml" ]; then
    cmd+=" -v ${DIR}/book.toml:/mdbook/book.toml"
  fi
  cmd+=" -v ${MDBOOK_SRC}:/mdbook/src --name ${CONTAINER_NAME} --rm -d ${IMAGE_NAME} server"
  echo $cmd
  echo $cmd | sh
  sleep 5
  echo ${OpenCmd} http://localhost:${PORT} | sh
  logs
}

build() {
  cmd="docker run"
  if [ -e "${DIR}/book.toml" ]; then
    cmd+=" -v ${DIR}/book.toml:/mdbook/book.toml"
  fi
  cmd+=" -v ${MDBOOK_SRC}:/mdbook/src --rm -d ${IMAGE_NAME} build -d /mdbook/src/docs"
  echo $cmd
  echo $cmd | sh
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

pull() {
  docker pull ${IMAGE_NAME}
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
  pull)
    pull
    ;;
  *)
    binPath=$0
    if [ "$binPath" == "bash" ] || [ "$binPath" == "sh" ]; then
      binPath="curl https://raw.githubusercontent.com/HillLiu/docker-mdbook/main/bin/preview.sh | bash -s --"
    fi
    echo "$binPath [start|stop|build|status|logs|pull]"
    exit
    ;;
esac

exit $?
