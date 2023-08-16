group "default" {
  targets = ["latest", "iron", "humble"]
}

target "latest" {
  target = "build-base-stage"
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
