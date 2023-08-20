import docker
from enum import Enum
from pathlib import Path
import os
import ros2_pkg_builder
import shutil
import argparse


def build_deb_packages(architecture: str, rosdistro: str, repos_file: str):
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
    client = docker.from_env()
    container = client.containers.run(
        image="wamvtan/ros2_pkg_builder:" + rosdistro,
        volumes={
            Path(architecture).absolute(): {
                "bind": "/artifacts",
                "mode": "rw",
            },
        },
        detach=True,
        remove=True,
    )
    output = container.attach(stdout=True, stream=True, logs=True)
    for line in output:
        print(line)


def main():
    parser = argparse.ArgumentParser(description="Building debian packages")
    parser.add_argument("architecture", choices=["amd64", "arm64"])
    parser.add_argument("rosdistro", choices=["rolling", "iron", "humble"])
    parser.add_argument(
        "--repos",
        help="repos file for your workspace",
        type=str,
        default="workspace.repos",
    )
    args = parser.parse_args()
    build_deb_packages(args.architecture, args.rosdistro, args.repos)


if __name__ == "__main__":
    main()
