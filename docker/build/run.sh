DSTDIR=$(pwd)/amd64/rosdep

if [ ! -d $DSTDIR ]; then
  mkdir -p $DSTDIR
fi

echo "" > $(pwd)/amd64/rosdep/humble.yaml
cp update_apt_repo.sh $(pwd)/amd64/update_apt_repo.sh
docker build -t build_packages .
docker run -it --rm --mount type=bind,source="$(pwd)"/amd64,target=/artifacts build_packages