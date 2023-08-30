#!/bin/bash
echo "Changing apt server to $APT_SERVER"
sed -i "s@archive.ubuntu.com@$APT_SERVER@g" /etc/apt/sources.list

PLATFORM=$(echo $TARGETPLATFORM | sed -E 's#linux/(.*)#\1#')

echo "yaml file:///artifacts/rosdep/${ROS_DISTRO}.yaml ${ROS_DISTRO}" | sudo tee /etc/ros/rosdep/sources.list.d/99-self-hosting-buildfarm.list

echo "deb [arch=${PLATFORM} trusted=yes] file:///artifacts jammy universe" | sudo tee /etc/apt/sources.list.d/self-hosting-buildfarm.list

cd /artifacts
sh update_apt_repo.sh

cd /workspace

vcs import . < workspace.repos

echo "Start making local rosdep.yaml"

colcon list -t -p | xargs -L 1 bash -c \
    'echo "Chang directory into $1"; cd "$1"; pkg=$(colcon list -n);pkg_with_prefix=$(echo $pkg|echo "ros-humble-"$(sed -e 's/_/-/g')); \
    yq eval -i ".\"$pkg\".ubuntu=[\"$pkg_with_prefix\"]" /artifacts/rosdep/${ROS_DISTRO}.yaml' _
rosdep update

echo "Start updating apt cache"

apt update
rosdep install -iy --from-paths . --skip-keys $(colcon list -n | tr '\n' ',')

cd /workspace && colcon list -t -p --packages-above $PACKAGES_ABOVE | xargs -I{} bash -c \
    'echo {} && cd {} && \
    rosdep install -iy --from-paths . && \
    bloom-generate rosdebian --os-name ubuntu --os-version $DEB_DISTRO --ros-distro $ROS_DISTRO && \
    fakeroot debian/rules binary && cd /artifacts && sh update_apt_repo.sh && \
    dpkg -i /artifacts/dists/$DEB_DISTRO/universe/binary-$ARCHITECTURE/ros-$ROS_DISTRO-*.deb'

echo $?
