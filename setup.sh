#!bin/bash
if [ $(uname) == "Darwin" ]; then
  OS="Mac"
elif [ $(expr substr $(uname -s) 1 5) == "Linux" ]; then OS="Linux"
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

if [ $OS == "Mac" ]; then
  xcode-select --install

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install git
elif [ $OS == "Linux" ]; then
  apt update -y
  apt install -y curl vim git net-tools build-essential software-properties-common
  apt install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev
fi

##############################
# fish shell #################
##############################
if [ $OS == "Mac" ]; then
  brew install fish
elif [ $OS == "Linux" ]; then
  sudo apt-add-repository ppa:fish-shell/release-3
  sudo apt update -y
  sudo apt install -y fish
fi
## fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fisher add jethrokuan/z

##############################
# fzf ########################
##############################
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

##############################
# anyenv #####################
##############################
if [ $OS == "Mac" ]; then
  brew install anyenv
  anyenv init
elif [ $OS == "Linux" ]; then
  git clone https://github.com/anyenv/anyenv ~/.anyenv
  echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile
  source ~/.profile
  anyenv init
  # anyenv install --init
fi
## Install plugins
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

##############################
# Python #####################
##############################
## Install pyenv
anyenv install pyenv
# echo 'export PATH="$HOME/.anyenv/envs/pyenv/bin:$PATH"' >> ~/.profile
# echo 'export PATH="$HOME/.anyenv/envs/pyenv/shims:$PATH"' >> ~/.profile
# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.profile
# source ~/.profile
# sudo ~/.anyenv/envs/pyenv/plugins/python-build/install.sh
pyenv rehash
## Install pipenv
if [ $OS == "Mac" ]; then
  brew install pipenv
elif [ $OS == "Linux" ]; then
  pip3 install --user pipenv
fi
## Install Python
#### Install 2.7.16
pyenv install 2.7.16
#### Install latest version
PYTHON_VERSION="$(pyenv install --list | fzf | xargs)"
pyenv install $PYTHON_VERSION

##############################
# Rust #######################
##############################
curl https://sh.rustup.rs -sSf | sh
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.profile
source ~/.profile
## Install Rust packages
cargo install bat exa ripgrep tokei

##############################
# Go #########################
##############################
## Install goenv
anyenv install goenv
echo 'export GOPATH="$HOME/go"' >> ~/.profile
echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.profile
echo 'export GOENV_DISABLE_GOPATH=1"' >> ~/.profile
source ~/.profile
goenv rehash
## Install Go
GO_VERSION="$(goenv install --list | fzf | xargs)"
goenv install $GO_VERSION
goenv global $GO_VERSION
## Install Go packages
go get github.com/motemen/ghq
go get github.com/jesseduffield/lazygit
go get github.com/jesseduffield/lazydocker

##############################
# Node #######################
##############################
## Install nodenv
anyenv install nodenv
nodenv rehash
## Install Node
NODE_VERSION="$(nodenv install --list | fzf | xargs)"
nodenv install $NODE_VERSION
nodenv global $NODE_VERSION
## Install yarn
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

##############################
# Neovim #####################
##############################
if [ $OS == "Mac" ]; then
  brew install neovim
  # brew install --HEAD neovim
elif [ $OS == "Linux" ]; then
  sudo add-apt-repository ppa:neovim-ppa/stable
  # sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update -y
  sudo apt install -y neovim 
fi
## Python2 provider
pyenv global 2.7.16
pip install --upgrade pip
pip install pynvim
## Python3 provider
pyenv global $PYTHON_VERSION
pip install --upgrade pip
pip install pynvim
## Node provider
yarn global add neovim
## Install dein.nvim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein

##############################
# Language Server ############
##############################
## Python Language Server
pip install 'python-language-server[all]'
## Rust Language Server
rustup component add rls rust-analysis rust-src
## VIM, Markdown Language Server
go get github.com/mattn/efm-langserver/cmd/efm-langserver
#### VIM linter
pip install vim-vint
#### Markdown linter
npm install -g markdownlint-cli

##############################
# Link dotfiles ##############
##############################
bash ~/dotfiles/link.sh
if [ $OS == "Linux" ]; then
  ln -snfv ~/dotfiles/.profile ~/
fi

##############################
# SSH key ####################
##############################
printf "Git email: "
read EMAIL_ADDRESS
ssh-keygen -t rsa -b 4096 -C $EMAIL_ADDRESS
FORMAT="\033[0m"
F_BOLD="\033[1m"
C_WHITE="\033[38;5;15m"
C_GREEN4="\033[48;5;28m"
echo -e "${F_BOLD}${C_WHITE}${C_GREEN4}Copy your ~/.ssh/id_rsa.pub, and add to Github.com${NO_FORMAT}"

if [ $OS == "Linux" ]; then
  sudo apt autoremove
fi
