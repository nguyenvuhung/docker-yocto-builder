#!/bin/sh

docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "vuhungkt18/docker-yocto-builder:latest" .


