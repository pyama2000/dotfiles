#!/bin/bash
set -ue

if [ $(uname) == "Darwin" ]; then
  OS="macOS"
elif [ $(expr substr $(uname -s) 1 5) == "Linux" ]; then
  OS="Linux"
else
  echo "Your platform ($(uname -a)) is not suppported."
  exit 1
fi

# if [ $OS == "macOS" ]; then
#   xcode-select --install
# fi

if [ $OS == "Linux" ]; then
  sudo apt update -y
  sudo apt install -y autoconf automake bison build-essential cmake curl \
    gettext git libbz2-dev libcurl4-gnutls-dev libevent-dev libexpat1-dev \
    libffi-dev libfreetype6-dev libfontconfig1-dev libghc-zlib-dev liblzma-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev \
    libxcb-xfixes0-dev llvm make pkg-config python-openssl python3 \
    software-properties-common tk-dev  wget xz-utils zlib1g-dev

fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

cargo install cargo-make
