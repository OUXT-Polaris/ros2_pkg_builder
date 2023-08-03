FROM builder
COPY workspace/ /workspace
WORKDIR /workspace
RUN vcs import . < workspace.repos
# RUN colcon list -t -p | xargs -L 1 bash -c 'cd "$1" && bloom-generate rosdebian --os-name ubuntu --os-version jammy --ros-distro humble && fakeroot debian/rules binary' _
# pkg=$(colcon list -n);pkg_with_prefix=$(echo $pkg|echo "ros-humble-"$(sed -e 's/_/-/g')); yq eval -i ".\"$pkg\".ubuntu=[\"$pkg_with_prefix\"]" rosdep.yaml