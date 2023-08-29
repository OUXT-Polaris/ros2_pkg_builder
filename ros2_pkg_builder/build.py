import argparse
import json
import os
import shutil
from logging import config, getLogger
from pathlib import Path

from python_on_whales import docker

import ros2_pkg_builder


def get_logger(logger_name: str):
    logger = getLogger(logger_name)
    with open(Path(ros2_pkg_builder.__path__[0]).joinpath("log_config.json"), "r") as f:
        log_conf = json.load(f)
    config.dictConfig(log_conf)
    return logger


def build_deb_packages(
    architecture: str,
    rosdistro: str,
    repos_file: str,
    build_builder_image: bool,
    packages_above: str,
    apt_server: str,
    cache_image: str,
) -> None:
    logger = get_logger(__name__)
    logger.info("Start building debian packages.")
    output_directory = Path(architecture).joinpath("rosdep")
    if not os.path.exists(output_directory):
        logger.info("makding directory at " + str(output_directory))
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
    if cache_image == "":
        logger.info(
            "Cache image was not specified, using ros:" + rosdistro + " as base image."
        )
        cache_image = "ros"
    else:
        logger.info(
            "Cache image was specified, using "
            + cache_image
            + ":"
            + rosdistro
            + " as base image."
        )
    if build_builder_image:
        logger.info("Building builder image for " + architecture + "/" + rosdistro)
        docker.buildx.bake(
            targets=[rosdistro],
            load=True,
            set={
                "*.platform": "linux/" + architecture,
                "*.context": Path(ros2_pkg_builder.__path__[0]).joinpath("docker"),
                "*.args.IMAGE_NAME": cache_image,
            },
            files=[
                Path(ros2_pkg_builder.__path__[0])
                .joinpath("docker")
                .joinpath("docker-bake.hcl")
            ],
        )
    docker.run(
        image="wamvtan/ros2_pkg_builder:" + rosdistro,
        volumes=[
            (Path(architecture).absolute(), "/artifacts"),
        ],
        remove=True,
        platform="linux/" + architecture,
        envs={
            "PACKAGES_ABOVE": packages_above,
            "ARCHITECTURE": architecture,
            "APT_SERVER": apt_server,
        },
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
    parser.add_argument(
        "--cache-image",
        type=str,
        default="",
        help="Docker image for caching rosdep dependency. \
            This image is used for base image of builder image. \
            If this value is empty, it means use no cache.",
    )
    parser.add_argument("--apt-server", type=str, default="ftp.jaist.ac.jp/pub/Linux")
    args = parser.parse_args()
    build_deb_packages(
        args.architecture,
        args.rosdistro,
        args.repos,
        args.build_builder_image,
        args.packages_above,
        args.apt_server,
        args.cache_image,
    )


if __name__ == "__main__":
    main()
