#!/bin/bash 

source .env

docker build \
  --build-arg USERNAME=${USERNAME} \
  --build-arg USER_UID=$(id -u) \
  -t dantorres3600/${CONTAINER_NAME}:${TAG} \
  -f Dockerfile .
