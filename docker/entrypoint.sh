#!/bin/bash
vcs import . < workspace.repos

apt update
rosdep install -iry --from-paths . --skip-keys $(colcon list -n | tr '\n' ',')

colcon list -t -p | xargs -L 1 bash -c \
    'cd "$1"; pkg=$(colcon list -n);pkg_with_prefix=$(echo $pkg|echo "ros-humble-"$(sed -e 's/_/-/g')); \
    yq eval -i ".\"$pkg\".ubuntu=[\"$pkg_with_prefix\"]" /artifacts/rosdep/${ROS_DISTRO}.yaml' _
rosdep update

cd /artifacts && sh update_apt_repo.sh

cd /workspace && colcon list -t -p --packages-up-to $PACKAGES_UP_TO | xargs -I{} bash -c \
    'echo {} && cd {} && \
    bloom-generate rosdebian --os-name ubuntu --os-version $DEB_DISTRO --ros-distro $ROS_DISTRO && \
    fakeroot debian/rules binary && cd /artifacts && sh update_apt_repo.sh && \
    dpkg -i /artifacts/dists/$DEB_DISTRO/universe/binary-amd64/*.deb'

echo $?
