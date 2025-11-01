#!/bin/bash

IMAGE_NAME=xr-teleoperate:latest
CONTAINER_NAME=${USER}-xr-teleoperate

if ! docker image inspect ${IMAGE_NAME} > /dev/null 2>&1; then
    echo "Docker image ${IMAGE_NAME} not found."
    echo "docker build -f docker/Dockerfile -t ${IMAGE_NAME} ."
    docker build -f docker/Dockerfile -t ${IMAGE_NAME} .
    exit 1
fi

if [ ! -f "${PWD}/teleop/televuer/cert.pem" ] || [ ! -f "${PWD}/teleop/televuer/key.pem" ]; then
    echo "cert.pem or key.pem not found under teleop/televuer/."
    echo "Run the following commands to generate the certificates:"
    echo "  $ cd teleop/televuer"
    echo "  $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem"
    exit 1
fi

xhost +local:docker
docker run -it --rm \
    --privileged \
    --network host \
    -e DISPLAY=$DISPLAY \
    -e QT_QPA_PLATFORM=xcb \
    -e QT_PLUGIN_PATH=/opt/conda/envs/tv/lib/qt/plugins \
    -e QT_DEBUG_PLUGINS=0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${PWD}:/workspace \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME}

# cd teleop && python teleop_hand_and_arm.py --xr-mode=hand --arm=G1_29 --ee=dex3 --sim --record