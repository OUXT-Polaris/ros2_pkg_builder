FROM builder
WORKDIR /workspace
COPY workspace.repos workspace.repos
RUN vcs import . < workspace.repos
ARG DEB_DISTRO=jammy
ENV DEB_DISTRO=${DEB_DISTRO}
ARG ROS_DISTRO=humble
RUN colcon list -t -p | xargs -L 1 bash -c 'cd "$1"; pkg=$(colcon list -n);pkg_with_prefix=$(echo $pkg|echo "ros-humble-"$(sed -e 's/_/-/g')); yq eval -i ".\"$pkg\".ubuntu=[\"$pkg_with_prefix\"]" /artifacts/rosdep/${ROS_DISTRO}.yaml' _
COPY update_apt_repo.sh /artifacts/update_apt_repo.sh
# RUN sh update_apt_repo.sh

# RUN colcon list -t -p | xargs -L 1 bash -c 'cd "$1" && bloom-generate rosdebian --os-name ubuntu --os-version jammy --ros-distro humble && fakeroot debian/rules binary' _
# pkg=$(colcon list -n);pkg_with_prefix=$(echo $pkg|echo "ros-humble-"$(sed -e 's/_/-/g')); yq eval -i ".\"$pkg\".ubuntu=[\"$pkg_with_prefix\"]" rosdep.yaml