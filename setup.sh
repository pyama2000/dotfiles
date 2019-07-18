#!bin/bash
if [ $(uname) == "Darwin" ]; then
  OS="Mac"
elif [ $(expr substr $(uname -s) 1 5) == "Linux" ]; then OS="Linux"
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# if [ $OS == "Mac" ]; then
#   xcode-select --install
# 
#   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#   brew install git
# elif [ $OS == "Linux" ]; then
#   apt update -y
#   apt install -y curl vim git net-tools build-essential software-properties-common
#   apt install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
#   test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
#   test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#   test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
#   echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
# fi

# if [ $OS == "Mac" ]; then
#   brew install fish
# elif [ $OS == "Linux" ]; then
#   printf "password: "
#   read password
#   echo "$password" | sudo -S apt-add-repository ppa:fish-shell/release-3
#   echo "$password" | sudo -S apt update -y
#   echo "$password" | sudo -S apt install -y fish
# fi
# curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

# if [ $OS == "Mac" ]; then
#   brew install anyenv
#   anyenv init
# elif [ $OS == "Linux" ]; then
#   git clone https://github.com/anyenv/anyenv ~/.anyenv
#   echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc
#   source ~/.bashrc
#   ~/.anyenv/bin/anyenv init
#   anyenv install --init
# fi
# mkdir -p $(anyenv root)/plugins
# git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# anyenv install pyenv
# echo 'export PATH="$HOME/.anyenv/envs/pyenv/bin:$PATH"' >> ~/.bashrc
# echo 'export PATH="$HOME/.anyenv/envs/pyenv/shims:$PATH"' >> ~/.bashrc
# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
# source ~/.bashrc
# sudo ~/.anyenv/envs/pyenv/plugins/python-build/install.sh
# pyenv rehash
# PYTHON_VERSION="$(pyenv install --list | fzf | xargs)"
# pyenv install $PYTHON_VERSION
# pyenv global $PYTHON_VERSION

# if [ $OS == "Mac" ]; then
#   brew install neovim
# elif [ $OS == "Linux" ]; then
#   # printf "password: "
#   # read password
#   echo "$password" | sudo -S add-apt-repository ppa:neovim-ppa/stable
#   echo "$password" | sudo -S apt update -y
#   echo "$password" | sudo -S apt install -y neovim 
# fi

# brew install pipenv

# curl https://sh.rustup.rs -sSf | sh

# cargo install bat
# cargo install exa
# cargo install ripgrep
# cargo install tokei

# curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
# sh ./installer.sh ~/.cache/dein

# pip install vim-vint
# npm install -g markdownlint-cli

# sudo apt autoremove
