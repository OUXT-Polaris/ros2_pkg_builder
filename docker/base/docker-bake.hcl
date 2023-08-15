group "default" {
  targets = ["latest", "iron", "humble"]
}

target "latest" {
  target = "build-base-stage"
  tags = ["docker.io/wamvtan/ros2_pkg_builder"]
  args = {
    "ROS_DISTRO" : "latest"
  }
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

target "rolling" {
  inherits = ["latest"]
  args = {
    "ROS_DISTRO" : "rolling"
  }
}

target "iron" {
  inherits = ["latest"]
  args = {
    "ROS_DISTRO" : "iron"
  }
}

target "humble" {
  inherits = ["latest"]
  args = {
    "ROS_DISTRO" : "humble"
  }
}
