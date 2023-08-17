DSTDIR=$(pwd)/amd64/rosdep

if [ ! -d $DSTDIR ]; then
  mkdir -p $DSTDIR
fi

echo "" > $(pwd)/amd64/rosdep/humble.yaml
cp update_apt_repo.sh $(pwd)/amd64/update_apt_repo.sh
cp workspace.repos $(pwd)/amd64/workspace.repos
docker build -t ros2_pkg_builder:humble .
docker run -it --rm --mount type=bind,source="$(pwd)"/amd64,target=/artifacts ros2_pkg_builder:humble