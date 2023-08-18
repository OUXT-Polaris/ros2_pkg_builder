import docker
from enum import Enum
from pathlib import Path
import os
import ros2_pkg_builder
import shutil
import argparse


class Rosdistro(Enum):
    ROLLING = 0
    IRON = 1
    HUMBLE = 2


class Architecture(Enum):
    AMD64 = 0
    ARM64 = 1


def build_deb_packages(architecture: str, rosdistro: Rosdistro, repos_file: str):
    architecture_str = ""
    if architecture == Architecture.AMD64:
        architecture_str = "amd64"
    elif architecture == Architecture.ARM64:
        architecture_str = "arm64"
    rosdistro_str = ""
    if rosdistro == Rosdistro.ROLLING:
        rosdistro_str = "rolling"
    elif rosdistro == Rosdistro.IRON:
        rosdistro_str = "iron"
    elif rosdistro == Rosdistro.HUMBLE:
        rosdistro_str = "humble"
    output_directory = Path(architecture_str).joinpath("rosdep")
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    with open(output_directory.joinpath(rosdistro_str + ".yaml"), "w") as f:
        f.write("")
    shutil.copyfile(
        Path(ros2_pkg_builder.__path__[0]).joinpath("update_apt_repo.sh"),
        Path(architecture_str).joinpath("update_apt_repo.sh"),
    )
    shutil.copyfile(repos_file, Path(architecture_str).joinpath("workspace.repos"))


def main():
    parser = argparse.ArgumentParser(description="Building debian packages")
    parser.add_argument(
        "--repos",
        help="repos file for your workspace",
        type=str,
        default="workspace.repos",
    )
    args = parser.parse_args()
    build_deb_packages(Architecture.AMD64, Rosdistro.HUMBLE, args.repos)


if __name__ == "__main__":
    main()
