# ros2_pkg_builder

## Base docker images are hosting on dockerhub.

[Dockerhub](https://hub.docker.com/r/wamvtan/ros2_pkg_builder)

## Requirements
- Operating System: Ubuntu (tested on 22.04)
- Docker
    - Add your user to the `docker` group to run Docker commands without `sudo`:
    ```
    sudo usermod -aG docker $USER && newgrp docker
    ```
    After running the above command, it might be necessary to reboot your machine.
- Poetry
    - This tools was tested under poetry 1.5.1

## Build your debian pacakges

Prepare repos file for your workspace.

### Command Usage
```bash
build_deb_packages --help

usage: build_deb_packages [-h] [--repos REPOS] {amd64,arm64} {rolling,iron,humble}

Building debian packages

positional arguments:
  {amd64,arm64}
  {rolling,iron,humble}

options:
  -h, --help            show this help message and exit
  --repos REPOS         repos file for your workspace
```
