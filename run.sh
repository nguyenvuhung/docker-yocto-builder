#!/bin/sh

# On host computer: create directory : $PWD/mediatek-bsp and $PWD/mediatek_output
mkdir -p $PWD/mediatek-bsp $PWD/mediatek_output
docker run -it --rm -v $PWD/mediatek_output:/home/build/yocto/mediatek-bsp/build vuhungkt18/docker-yocto-builder:latest


