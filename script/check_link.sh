#!/bin/bash

LINK=(".commit_template" ".gitconfig" ".hyper.js" 
      ".config/starship.toml" ".config/nvim" ".config/coc"
      ".config/fish/config.fish")

# Exit if error is occured
set -eu -o pipefail
trap 'echo "ERROR: line no = $LINENO, exit status = $?" >&2; exit 1' ERR

if [ $(uname) == "Darwin" ]; then
  OS="Mac"
elif [ $(expr substr $(uname -s) 1 5) == "Linux" ]; then OS="Linux"
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# Checking the files / directorys is the link
for link in ${LINK[@]}
do
  echo $HOME/dotfiles/$link
  if [ ! -L $HOME/$link ]; then
    ln -snfv $HOME/dotfiles/$link $HOME/
  fi
done
