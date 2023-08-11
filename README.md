# ros2_pkg_builder

## requirements
- Ubuntu (test on 22.04)
- docker
    - recommend this command
    ```
    sudo usermod -aG docker $USER && newgrp docker
    reboot
    ```

## make deb pkg
1. clone this repo
    ```
    cd ~/
    git clone https://github.com/OUXT-Polaris/ros2_pkg_builder.git
    ```
2. make base image
    ```
    cd ~/ros2_pkg_builder/docker/base
    docker build -t builder .
    ```
3. create && write .repo file
    ```
    cd ~/ros2_pkg_builder/docker/build/
    touch workspace.repos
    ```

    write this .repos file. This is example .repo
    ```
    # example workspace.repos
    repositories:
    message/roboware_msg:
        type: git
        url: https://github.com/hakoroboken/roboware_msg.git
        version: main
    ```

4. make .deb pkg
    ```
    cd ~/ros2_pkg_builder/docker/build/
    chmod +x ./*.sh
    ./run.sh
    ```
