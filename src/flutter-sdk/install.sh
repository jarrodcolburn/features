#!/bin/sh
# shellcheck disable=SC2039
# shellcheck disable=SC2155
set -e

# shellcheck disable=SC2034
DEBIAN_FRONTEND="noninteractive"
RELEASES_URL="https://storage.googleapis.com/flutter_infra_release/releases"
TMP_DIR="/tmp/flutter"
RELEASES_JSON="releases_linux.json"

# Install dependencies
apt update
apt install -y --no-install-recommends bash curl file git unzip xz-utils zip libglu1-mesa jq xz-utils

# Get latest releases
mkdir "$TMP_DIR"
cd "$TMP_DIR"
wget "$RELEASES_URL/$RELEASES_JSON"

# Download and extract Flutter SDK
HASH=$(jq ".current_release.$RELEASE" $RELEASES_JSON)
FLUTTER_ARCHIVE=$(jq -r ".releases[] | select(.hash==$HASH) | .archive" releases_linux.json)
wget "$RELEASES_URL/$FLUTTER_ARCHIVE"
tar -xf "$TMP_DIR/$(basename "$FLUTTER_ARCHIVE")" -C "$(dirname "$FLUTTER_HOME")"
chown --recursive "$_REMOTE_USER:$_REMOTE_USER" "$FLUTTER_HOME"
git config --global --add safe.directory "$FLUTTER_HOME"

# Clean up
cd ~
rm -rf "$TMP_DIR"
apt clean

# Verify installation
su - "$_REMOTE_USER" 
flutter doctor