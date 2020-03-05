#!/bin/sh

# On host computer: create directory : $PWD/mediatek-bsp and $PWD/mediatek_output
mkdir -p $PWD/mediatek-bsp $PWD/mediatek_output
docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "vuhungkt18/docker-yocto-builder:latest" .
docker run -it --rm -v $PWD/mediatek_output:/home/build/yocto/mediatek-bsp/build vuhungkt18/docker-yocto-builder:latest


