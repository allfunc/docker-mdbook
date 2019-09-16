#!/bin/bash

start() {
  stop
  docker run -d -p 3000:3000 -p 3001:3001 -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(pwd)/mdbook-demo/src:/mdbook/src" --name mdbook hillliu/mdbook serve -n 0.0.0.0 
}

stop() {
  docker stop mdbook
  docker rm mdbook
}

logs() {
  docker logs -f mdbook
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop 
    ;;
  logs)
    logs 
    ;;
  *)
    echo "$0 [start|stop|logs]" 
    exit
esac

exit $?  
