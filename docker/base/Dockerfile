ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO} as build-base-stage
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    python3-bloom fakeroot dpkg-dev debhelper wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
