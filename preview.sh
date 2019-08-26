#!/bin/bash

start() {
docker run -d -p 3000:80 -p 3001:3001 -v "$(pwd):/mdbook/src" --name mdbook hillliu/mdbook serve -p 80 -n 0.0.0.0
}

stop() {
docker stop mdbook
docker rm mdbook
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop 
    ;;
  *)
    echo "$0 [start|stop]" 
    exit
esac

exit $?  
