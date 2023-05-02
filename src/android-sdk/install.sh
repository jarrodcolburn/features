#!/bin/sh
# shellcheck disable=SC2039
set -e

LATEST="9477386"
URL="https://dl.google.com/android/repository"
# shellcheck disable=SC2027
ARCHIVE="commandlinetools-linux-"$LATEST"_latest.zip"
FOLDER="cmdline-tools"

# Install Dependencies
DEBIAN_FRONTEND="noninteractive" sudo apt update && 
sudo apt install --no-install-recommends -y openjdk-11-jdk-headless unzip wget &&
sudo apt clean

# Create the folder for the Android SDK
sudo -u "$_REMOTE_USER" mkdir -p "$ANDROID_HOME/$FOLDER"

# Download and extract the latest Android SDK command line tools
sudo -u "$_REMOTE_USER" wget -q "$URL/$ARCHIVE"
sudo -u "$_REMOTE_USER" unzip -q "$ARCHIVE"
sudo -u "$_REMOTE_USER" rm -rf "$ARCHIVE"
sudo -u "$_REMOTE_USER" mv -f "$FOLDER" "$ANDROID_HOME/$FOLDER/latest"
sudo -u "$_REMOTE_USER" rm -rf "$FOLDER"

# Change ownership of the Android SDK folder
sudo chown -R "$_REMOTE_USER:$_REMOTE_USER" "$ANDROID_HOME"


# Build a space-separated list of packages to install
PACKAGES="platform-tools patcher;v4"
if [ "$PLATFORMS" != "none" ]; then
    PACKAGES="$PACKAGES platforms;android-$PLATFORMS"
fi

if [ "${BUILD-TOOLS}" != "none" ]; then
    PACKAGES="$PACKAGES build-tools;${BUILD-TOOLS}"
fi

sudo -u "$_REMOTE_USER" "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --install $PACKAGES