group "builder" {
  targets = ["latest", "iron", "humble", "rolling"]
}

target "latest" {
  target = "build-stage"
  dockerfile = "Dockerfile.builder"
  tags = ["docker.io/wamvtan/ros2_pkg_builder:latest"]
  args = {
    "ROS_DISTRO" : "latest"
  }
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

target "rolling" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:rolling"]
  args = {
    "ROS_DISTRO" : "rolling"
  }
}

target "iron" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:iron"]
  args = {
    "ROS_DISTRO" : "iron"
  }
}

target "humble" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:humble"]
  args = {
    "ROS_DISTRO" : "humble"
  }
}

// Grid map does not released in comment outed distribution
group "cache" {
  targets = ["cache-latest", "cache-humble"] # "cache-iron", "cache-rolling" ]
}

target "cache-latest" {
  target = "cache-stage"
  dockerfile = "Dockerfile.cache"
  tags = ["docker.io/wamvtan/robotx_buildfarm:latest"]
  args = {
    "ROS_DISTRO" : "latest",
    "REPOS_FILE" : "https://raw.githubusercontent.com/OUXT-Polaris/ros2_pkg_builder/ouxt/repos/workspace.repos"
  }
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

target "cache-rolling" {
  inherits = ["cache-latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:rolling"]
  args = {
    "ROS_DISTRO" : "rolling"
  }
}

target "cache-iron" {
  inherits = ["cache-latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:iron"]
  args = {
    "ROS_DISTRO" : "iron"
  }
}

target "cache-humble" {
  inherits = ["cache-latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:humble"]
  args = {
    "ROS_DISTRO" : "humble"
  }
}
