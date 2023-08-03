group "default" {
  targets = ["builder"]
}

target "builder" {
  target = "build-base-stage"
  tags = ["ros2_pkg_builder"]
  args = {
    "ROS_DISTRO" : "humble"
  }
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/arm/v7"]
}
