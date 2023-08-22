import argparse
import os
import shutil
from pathlib import Path

from python_on_whales import docker

import ros2_pkg_builder


def build_deb_packages(
    architecture: str,
    rosdistro: str,
    repos_file: str,
    build_builder_image: bool,
    packages_above: str,
) -> None:
    output_directory = Path(architecture).joinpath("rosdep")
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    with open(output_directory.joinpath(rosdistro + ".yaml"), "w") as f:
        f.write("")
    shutil.copyfile(
        Path(ros2_pkg_builder.__path__[0]).joinpath("update_apt_repo.sh"),
        Path(architecture).joinpath("update_apt_repo.sh"),
    )
    shutil.copyfile(repos_file, Path(architecture).joinpath("workspace.repos"))
    if build_builder_image:
        docker.buildx.bake(
            [rosdistro],
            load=True,
            set={
                "*.platform": "linux/" + architecture,
                "*.context": Path(ros2_pkg_builder.__path__[0]).joinpath("docker"),
            },
            files=[
                Path(ros2_pkg_builder.__path__[0])
                .joinpath("docker")
                .joinpath("docker-bake.hcl")
            ],
        )
    docker.run(
        image="wamvtan/ros2_pkg_builder:" + rosdistro,
        volumes=[(Path(architecture).absolute(), "/artifacts")],
        remove=True,
        platform="linux/" + architecture,
        envs={"PACKAGES_ABOVE": packages_above, "ARCHITECTURE": architecture},
        tty=True,
    )


def main():
    parser = argparse.ArgumentParser(description="Building debian packages")
    parser.add_argument(
        "architecture",
        choices=["amd64", "arm64"],
        help="Target CPU architecture.",
    )
    parser.add_argument(
        "rosdistro",
        choices=["rolling", "iron", "humble"],
        help="Target ROS 2 distribution.",
    )
    parser.add_argument(
        "--repos",
        help="repos file for your workspace",
        type=str,
        default="workspace.repos",
    )
    parser.add_argument(
        "--build-builder-image",
        action="store_true",
        help="If true, build builder images in your local machine.",
    )
    parser.add_argument(
        "--packages-above",
        type=str,
        default="",
        help="List of build target packages.",
    )
    args = parser.parse_args()
    build_deb_packages(
        args.architecture,
        args.rosdistro,
        args.repos,
        args.build_builder_image,
        args.packages_above,
    )


if __name__ == "__main__":
    main()
