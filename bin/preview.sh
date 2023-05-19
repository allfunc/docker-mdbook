#!/usr/bin/env sh
DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"
ENV="${DIR}/.env"
IMAGE_NAME="allfunc/mdbook"

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

PORT=${PORT:-3888}
MDBOOK_SRC=${MDBOOK_SRC:-$DIR}
CONTAINER_NAME=${CONTAINER_NAME:-mdbook}

open() {
  OpenCmd=$(which xdg-open 2> /dev/null)
  case "$OSTYPE" in
    linux*) ;;

    darwin*)
      OpenCmd="open"
      ;;
    *) ;;

  esac
  if [ -z "$OpenCmd" ]; then
    OpenCmd="echo"
  fi
  echo ${OpenCmd} http://localhost:${PORT} | sh
}

start() {
  # echo $MDBOOK_SRC
  # echo $CONTAINER_NAME
  # echo $PORT
  # exit;
  stop
  watchMode=$1
  cmd="docker run -p ${PORT}:${PORT} -e PORT=${PORT} -u $(id -u):$(id -g)"
  if [ -e "${DIR}/book.toml" ]; then
    cmd+=" -v ${DIR}/book.toml:/mdbook/book.toml"
  fi
  cmd+=" -v ${MDBOOK_SRC}:/mdbook/src --name ${CONTAINER_NAME} --rm"
  cmd1="${cmd} -d ${IMAGE_NAME} server"
  cmd2="${cmd} ${IMAGE_NAME} server"
  echo $cmd2
  echo $cmd1 | sh
  sleep 5
  if [ -n "$watchMode" ]; then
    watch
  fi
  open
  logs || echo $cmd2 | sh
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
    sleep 1
  fi
  pgrep -lf "/tmp/mdbook" | awk '{print $1}' | xargs -I{} kill -9 {}
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

watch() {
  pid=$$
  watchfile=/tmp/mdbook-${pid}
  logfile=/tmp/mdbook-${pid}.log
  cat > ${watchfile} << EOF
#!/usr/bin/env sh
WATCH_FOLDER=${MDBOOK_SRC}
TOUCH='docker exec mdbook do-touch'

echo
echo 'Start to monitor: '\${WATCH_FOLDER}
echo

while true; do
  isRunning=\$(docker container ls --filter name=mdbook --format '{{.Names}}' | head -n 1)
  if [ -z "\${isRunning}" ]; then
    echo
    echo 'Stop monitor: '\${WATCH_FOLDER}
    echo
    break;
  fi
  find \${WATCH_FOLDER} -newer ${watchfile} -type f \( ! -path "*.sw*" \) -print -a -exec sh -c 'new_path="\${1#\$2/}"; \$3 \$new_path' _ {} "\$WATCH_FOLDER" "\$TOUCH" \;
  touch ${watchfile}
  sleep 1
done
EOF
  chmod 0755 ${watchfile}
  sh -c ${watchfile} > ${logfile} 2>&1 &
}

case "$1" in
  start)
    start
    ;;
  watch)
    start watch
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
  open)
    open
    ;;
  *)
    binPath=$0
    if [ "$binPath" == "bash" ] || [ "$binPath" == "sh" ]; then
      binPath="curl https://raw.githubusercontent.com/HillLiu/docker-mdbook/main/bin/preview.sh | bash -s --"
    fi
    echo "$binPath [start|watch|stop|build|status|logs|pull|open]"
    exit
    ;;
esac

exit $?
