#!/bin/bash 

source .env
CONTAINER_HOME=/home/${USERNAME}
CONTAINER_WORKDIR=${CONTAINER_HOME}/sandbox
IMAGE_NAME=dantorres3600/${CONTAINER_NAME}:${TAG}

xhost +local:docker > /dev/null 2>&1 

docker run -it --rm \
  --network host \
  --privileged \
  --gpus=all \
  -e DISPLAY=${DISPLAY} \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /etc/localtime:/etc/localtime:ro \
  -v ~/projects/computer_vision/sandbox/:${CONTAINER_WORKDIR} \
  --name=${CONTAINER_NAME} \
  --user ${USERNAME} \
  --workdir ${CONTAINER_WORKDIR} \
  ${IMAGE_NAME} /bin/bash
