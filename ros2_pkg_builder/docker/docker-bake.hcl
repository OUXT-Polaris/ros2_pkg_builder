group "default" {
  targets = ["latest", "iron", "humble", "rolling"]
}

target "latest" {
  target = "build-base-stage"
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

target "latest-cacher" {
  inherits = ["latest"]
  target = "build-cacher-stage"
  docker = "Dockerfile.cacher"
  tags = ["docker.io/wamvtan/ros2_pkg_builder:cacher_latest"]
  platforms = ["linux/amd64"] #, "linux/arm64/v8"] // Some apt packages are not supported in arm.
}

target "rolling-cacher" {
  inherits = ["latest-cacher"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:cacher_rolling"]
}

target "iron-cacher" {
  inherits = ["latest-cacher"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:cacher_iron"]
}

target "humble-cacher" {
  inherits = ["latest-cacher"]
  tags = ["docker.io/wamvtan/ros2_pkg_builder:cacher_humble"]
}
