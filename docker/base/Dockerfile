ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO} as build-base-stage
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    python3-bloom fakeroot dpkg-dev debhelper wget apt-utils\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
RUN mkdir -p /artifacts/rosdep
RUN touch /artifacts/rosdep/${ROS_DISTRO}.yaml
RUN echo "yaml file:///artifacts/rosdep/${ROS_DISTRO}.yaml ${ROS_DISTRO}" | sudo tee /etc/ros/rosdep/sources.list.d/99-self-hosting-buildfarm.list
RUN echo "deb [arch=amd64 trusted=yes] file:///artifacts jammy universe" | sudo tee /etc/apt/sources.list.d/self-hosting-buildfarm.list