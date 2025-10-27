#!/usr/bin/env bash

operation=$1
registry=$2
image=$3
targets=${@:4}

set -euo pipefail

case "$operation" in
  build)
    dockerfiles=()

    tmp=$image
    while [[ -n "$tmp" ]]; do
      match="";
      for t in $targets; do
        case "$tmp" in
          $t*) match=$t;
               ;;
        esac;
      done;
      if [[ -n "$match" ]]; then
        dockerfiles+=("Dockerfile.$match");
        tmp=${tmp#$match};
        tmp=${tmp#-};
      else
        break;
      fi;
    done;
    if [[ ${#dockerfiles[@]} -eq 0 || -n "$tmp" ]]; then
      echo "unable to substitute $image" >&2; exit 1;
    fi;

    if [[ ${#dockerfiles[@]} -ne 1 ]]; then
      image_dockerfile=".Dockerfile.$image"

      cat "${dockerfiles[0]}" > $image_dockerfile
      for ((i=1; i < ${#dockerfiles[@]}; i++)) do
        sed '/^[[:space:]]*FROM[[:space:]]*/d' "${dockerfiles[$i]}" >> $image_dockerfile
      done;
    else
      image_dockerfile=${dockerfiles[0]}
    fi

    docker build -f $image_dockerfile -t $image .

    if [[ ${#dockerfiles[@]} -ne 1 ]]; then
      rm $image_dockerfile
    fi
    ;;
  tag)
    docker tag $image $registry/$image
    docker rmi $image
    ;;
  push)
    docker push $registry/$image
    ;;
  *)
    echo "$0 <build|tag|push> <registry> <image> <targets...>"
    exit 1
    ;;
esac
