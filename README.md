# docker-yocto-builder
docker-yocto-builder: Docker container to make enviroment to build yocto

# How to build and run docker on Host computer
On host computer: create directory : yocto/mediatek-bsp and yocto/mediatek_output
# mkdir -p yocto/mediatek-bsp
# mkdir -p yocto/mediatek_output

Build the Docker image with the following command:
# docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "vuhungkt18/docker-yocto-builder:latest" .
Run the Docker image, which in turn runs the Yocto and which produces the Linux rootfs,with the following command:
# docker run -it --rm -v $PWD/yocto/mediatek_output:/home/build/yocto/mediatek-bsp/build vuhungkt18/docker-yocto-builder:latest
