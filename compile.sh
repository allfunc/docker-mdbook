#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
sourceImage=`./sourceImage.sh`
targetImage=`./targetImage.sh`
archiveFile=$DIR/archive.tar

tag(){
  tag=$1
  if [ -z $tag ]; then
    tag=latest
  fi
  echo "* <!-- Start to tag"
  echo $tag
  docker tag $sourceImage ${targetImage}:$tag
  docker images | head -10 
  echo "* Finish tag -->"
}

push(){
  echo "* <!-- Start to push"
  docker login
  docker push ${targetImage}
  echo "* Finish to push -->"
}

build(){
  docker-compose -f build.yml build $1
}

save() {
  echo save
  docker save $sourceImage > $archiveFile
}

restore() {
  echo restore
  docker save --output $archiveFile $sourceImage
}

case "$1" in
  save)
    save
    ;;
  restore)
    restore
    ;;
  p)
    push
    ;;
  t)
    tag $2 
    ;;
  nocache)  
    build --no-cache
    ;;
  auto)
    build 
    tag
    ;;
  b)  
    build
    ;;
  *)
    echo "$0 [save|restore|p|t|nocache|auto|b]" 
    exit
esac

exit $?
