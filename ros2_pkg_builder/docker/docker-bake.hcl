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

group "cache" {
  targets = ["cache-latest", "cache-iron", "cache-humble", "cache-rolling"]
}

target "cache-latest" {
  target = "cache-stage"
  dockerfile = "Dockerfile.cache"
  tags = ["docker.io/wamvtan/robotx_buildfarm:cache-latest"]
  args = {
    "ROS_DISTRO" : "latest"
  }
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

target "cache-rolling" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:cache-rolling"]
  args = {
    "ROS_DISTRO" : "rolling"
  }
}

target "cache-iron" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:cache-iron"]
  args = {
    "ROS_DISTRO" : "iron"
  }
}

target "cache-humble" {
  inherits = ["latest"]
  tags = ["docker.io/wamvtan/robotx_buildfarm:cache-humble"]
  args = {
    "ROS_DISTRO" : "humble"
  }
}
