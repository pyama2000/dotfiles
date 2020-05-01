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
  sudo apt install -y curl build-essential software-properties-common
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# cargo install cargo-make
