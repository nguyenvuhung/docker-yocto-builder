docker-yocto-builder: Docker container to make enviroment to build yocto

# How to build and run docker on Host computer
On host computer: create directory : $PWD/mediatek-bsp and $PWD/mediatek_output 

#mkdir -p $PWD/mediatek-bsp
#mkdir -p $PWD/mediatek_output

# Build the Docker image with the following command:
#docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "vuhungkt18/docker-yocto-builder:latest" .
# Run the Docker image, which in turn runs the Yocto and which produces the Linux rootfs,with the following command:
#docker run -it --rm -v $PWD/mediatek_output:/home/build/yocto/mediatek-bsp/build vuhungkt18/docker-yocto-builder:latest
