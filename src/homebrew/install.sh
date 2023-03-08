#!/bin/sh
# shellcheck disable=SC2039
# shellcheck disable=SC2155
set -e

# shellcheck disable=SC2034
echo "Installing Dependencies"
export DEBIAN_FRONTEND="noninteractive"
apt update >> /dev/null
apt install -y build-essential procps curl file git && apt clean >> /dev/null

echo "Installing Homebrew"
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> /dev/null

# Install recommended packages
if [[ ${INSTALL-RECOMMENDS} ]]; then
    echo "Installing recommended packages"
    brew install gcc >> /dev/null
else
    echo "Skipping recommended packages"
fi
