#!/bin/sh
# SPDX-License-Identifier: BSD-3-Clause

set -ex

echo "Move packages"
RELEASE_DIR="dists/$DEB_DISTRO"

PLATFORM=$(echo $TARGETPLATFORM | sed -E 's#linux/(.*)#\1#')

echo "Updating apt repository for platform $TARGETPLATFORM"

PACKAGE_DIR="dists/$DEB_DISTRO/universe/binary-$PLATFORM"
mkdir -p "$PACKAGE_DIR"
for file in $(find /workspace -type f -name *.deb); do mv "$file" "$PACKAGE_DIR"; done

echo "Suite: $DEB_DISTRO" > "$RELEASE_DIR/Release"
echo "Components: universe" >> "$RELEASE_DIR/Release"
echo "Architectures: $PLATFORM" >> "$RELEASE_DIR/Release"

apt-ftparchive packages "$PACKAGE_DIR" > "$PACKAGE_DIR/Packages"
apt-ftparchive release "$RELEASE_DIR" >> "$RELEASE_DIR/Release"
