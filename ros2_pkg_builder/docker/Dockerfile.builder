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

WORKDIR /workspace
RUN echo "repositories:" >> workspace.repos

ARG DEB_DISTRO=jammy
ENV DEB_DISTRO=${DEB_DISTRO}
ARG ROS_DISTRO=humble
ENV ROS_DISTRO=${ROS_DISTRO}

COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

RUN echo 'Acquire::http::Proxy "http://localhost:4000";' | sudo tee /etc/apt/apt.conf.d/02proxy

ENTRYPOINT [ "/bin/bash", "-c", "cp /artifacts/workspace.repos /workspace/workspace.repos && source /opt/ros/${ROS_DISTRO}/setup.bash && /workspace/entrypoint.sh"]
