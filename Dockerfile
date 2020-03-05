# Copyright 2019, Burkhard Stubert (DBA Embedded Use)

# In any directory on the docker host, perform the following actions:
#   * Copy this Dockerfile in the directory.
#   * Create input and output directories: mkdir -p yocto/output yocto/input
#   * Build the Docker image with the following command:
#     docker build --no-cache --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" \
#         --tag "cuteradio-image:latest" .
#   * Run the Docker image, which in turn runs the Yocto and which produces the Linux rootfs,
#     with the following command:
#     docker run -it --rm -v $PWD/yocto/output:/home/cuteradio/yocto/output cuteradio-image:latest

# Use Ubuntu 16.04 LTS as the basis for the Docker image.
FROM ubuntu:16.04
MAINTAINER Nguyen Vu Hung <hungnv9@vng.com.vn>
# Install all the Linux packages required for Yocto builds. Note that the packages python3,
# tar, locales and cpio are not listed in the official Yocto documentation. The build, however,
# without them.
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales curl

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install repo
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo

# Configuration git
RUN git config --global user.email "hungnv9@vng.com.vn"
RUN git config --global user.name "Nguyen Vu Hung"

ENV USER_NAME build
ENV PROJECT mediatek

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is cuteradio.
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# Perform the Yocto build as user cuteradio (not as root).
# NOTE: The USER command does not set the environment variable HOME.

# By default, docker runs as root. However, Yocto builds should not be run as root, but as a 
# normal user. Hence, we switch to the newly created user cuteradio.
USER $USER_NAME

# Set mediatek BSP branch
ENV MEDIATEK_BRANCH "zeus_mediatek"

# Create the directory structure for the Yocto build in the container. The lowest two directory
# levels must be the same as on the host.
ENV MEDIATEK_PATH /home/$USER_NAME/yocto/mediatek-bsp
ENV BUILD_OUTPUT_DIR /home/$USER_NAME/yocto/mediatek-bsp/build
RUN mkdir -p $MEDIATEK_PATH $BUILD_OUTPUT_DIR

# Clone the repositories of the meta layers into the directory $BUILD_INPUT_DIR/sources/cuteradio.
WORKDIR $MEDIATEK_PATH

RUN repo init -u https://github.com/nguyenvuhung/bbb-community-bsp-platform -b ${MEDIATEK_BRANCH}
RUN repo sync -j8
ENV MACHINE mt7623-bpi-r2
ENV DISTRO poky
CMD source $MEDIATEK_PATH/setup-environment build && bitbake qt5-image-demo-swu



