FROM builder
WORKDIR /workspace
COPY workspace.repos workspace.repos
RUN vcs import . < workspace.repos
ARG DEB_DISTRO=jammy
ENV DEB_DISTRO=${DEB_DISTRO}
ARG ROS_DISTRO=humble
ENV ROS_DISTRO=${ROS_DISTRO}
COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh
RUN touch /artifacts/rosdep/${ROS_DISTRO}.yaml

ENTRYPOINT [ "/bin/bash", "-c", "source /opt/ros/${ROS_DISTRO}/setup.bash && /workspace/entrypoint.sh"]
