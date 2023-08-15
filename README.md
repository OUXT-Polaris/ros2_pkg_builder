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

## Building the Debian Package (`.deb`)

1. **Clone the Repository:**
    ```bash
    cd ~/
    git clone https://github.com/OUXT-Polaris/ros2_pkg_builder.git
    ```

2. **Create Base Image:**
    ```bash
    cd ~/ros2_pkg_builder/docker/base
    docker build -t builder .
    ```

3. **Create and Configure `.repos` File:**
    ```bash
    cd ~/ros2_pkg_builder/docker/build/
    touch workspace.repos
    ```
    Add the following content to the `workspace.repos` file (this is just an example):
    ```yaml
    # example workspace.repos
    repositories:
      message/roboware_msg:
        type: git
        url: https://github.com/hakoroboken/roboware_msg.git
        version: main
    ```

4. **Generate the `.deb` Package:**
    ```bash
    cd ~/ros2_pkg_builder/docker/build/
    chmod +x ./*.sh
    ./run.sh
    ```
