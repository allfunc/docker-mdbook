#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
sourceImage=`${DIR}/support/sourceImage.sh`
targetImage=`${DIR}/support/targetImage.sh`
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
  if [ -z "$1" ]; then
    NO_CACHE=""
  else  
    NO_CACHE="--no-cache"
  fi  
  docker build ${NO_CACHE} -f ${DIR}/Dockerfile -t $sourceImage ${DIR}
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
    build $2
    tag
    ;;
  b)  
    build $2
    ;;
  *)
    echo "$0 [save|restore|p|t|nocache|auto|b]" 
    exit
esac

exit $?
