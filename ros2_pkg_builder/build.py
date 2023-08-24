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
    apt_server: str,
    cacher_image_name: str,
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
    shutil.copyfile(
        repos_file,
        Path(ros2_pkg_builder.__path__[0])
        .joinpath("docker")
        .joinpath("workspace.repos"),
    )
    if build_builder_image:
        docker.buildx.bake(
            targets=[rosdistro],
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
        docker.buildx.bake(
            targets=[rosdistro, rosdistro + "-cacher"],
            load=True,
            set={
                "*.platform": "linux/" + architecture,
                "*.context": Path(ros2_pkg_builder.__path__[0]).joinpath("docker"),
                "*.tags": cacher_image_name + ":" + rosdistro,
            },
            files=[
                Path(ros2_pkg_builder.__path__[0])
                .joinpath("docker")
                .joinpath("docker-bake.hcl")
            ],
        )
    # docker.run(
    #     image="wamvtan/ros2_pkg_builder:" + rosdistro,
    #     volumes=[
    #         (Path(architecture).absolute(), "/artifacts"),
    #     ],
    #     remove=False,
    #     platform="linux/" + architecture,
    #     envs={
    #         "PACKAGES_ABOVE": packages_above,
    #         "ARCHITECTURE": architecture,
    #         "APT_SERVER": apt_server,
    #     },
    #     tty=True,
    # )


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
    parser.add_argument("--apt-server", type=str, default="ftp.jaist.ac.jp/pub/Linux")
    parser.add_argument(
        "--cacher-image-name",
        type=str,
        default="docker.io/wamvtan/ros2_pkg_builder_cacher",
    )
    args = parser.parse_args()
    build_deb_packages(
        args.architecture,
        args.rosdistro,
        args.repos,
        args.build_builder_image,
        args.packages_above,
        args.apt_server,
        args.cacher_image_name,
    )


if __name__ == "__main__":
    main()
