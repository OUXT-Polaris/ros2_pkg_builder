ARG ROS_DISTRO=humble
ARG IMAGE_NAME=ros
FROM ${IMAGE_NAME}:${ROS_DISTRO} as build-stage

SHELL ["/bin/bash", "-c"]

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

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}
ENV ROS_DISTRO=${ROS_DISTRO}

WORKDIR /workspace
RUN echo "repositories:" >> workspace.repos

ARG DEB_DISTRO=jammy
ENV DEB_DISTRO=${DEB_DISTRO}
ARG ROS_DISTRO=humble

COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

ENTRYPOINT [ "/bin/bash", "-c", "cp /artifacts/workspace.repos /workspace/workspace.repos && source /opt/ros/${ROS_DISTRO}/setup.bash && /workspace/entrypoint.sh"]
