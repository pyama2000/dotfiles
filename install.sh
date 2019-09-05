#!bin/bash
PYTHON_VERSION=3.7.4
GO_VERSION=1.12.7
NODE_VERSION=12.6.0

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

# Ask to install
function want_install {
  read -p "Do you want to install $* [Y/n]: " answer
  case $answer in
    [nN]*) return 1 ;;
    *)     return 0 ;;
  esac
}

##############################
# setup ######################
##############################
if [ $OS == "Mac" ]; then
  xcode-select --install

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install git readline xz
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
if !(type fish > /dev/null 2>&1) && want_install "fish"; then
  ## install fish shell
  if [ $OS == "Mac" ]; then
    brew install fish
  elif [ $OS == "Linux" ]; then
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt update -y
    sudo apt install -y fish
  fi
  ## Install fisher
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
  fish -c "fisher add jethrokuan/z"
fi

##############################
# fzf ########################
##############################
if !(type fzf > /dev/null 2>&1) && want_install "fzf"; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

##############################
# anyenv #####################
##############################
if !(type anyenv > /dev/null 2>&1) && want_install "anyenv"; then
  ## Install anyenv
  if [ $OS == "Mac" ]; then
    brew install anyenv
    anyenv init
  elif [ $OS == "Linux" ]; then
    git clone https://github.com/anyenv/anyenv ~/.anyenv
    echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile
    echo 'eval "$(anyenv init -)"' >> ~/.profile
    source ~/.profile
    anyenv install --init
  fi
  ## Install plugins
  mkdir -p $(anyenv root)/plugins
  git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
fi

##############################
# Python #####################
##############################
if want_install "Python with pyenv"; then
  ## Install pyenv
  anyenv install pyenv
  source ~/.profile
  pyenv rehash
  ## Install Python
  #### Install 2.7.16
  pyenv install 2.7.16
  #### Install latest version
  pyenv install $PYTHON_VERSION
  pyenv global $PYTHON_VERSION
  ## Install pipenv
  if [ $OS == "Mac" ]; then
    brew install pipenv
  elif [ $OS == "Linux" ]; then
    pip3 install --user pipenv
  fi
fi

##############################
# Rust #######################
##############################
if !(type rustc > /dev/null 2>&1) && want_install "Rust"; then
  ## Install Rust
  curl https://sh.rustup.rs -sSf | sh
  source ~/.profile
  rustup install nightly
  ## Install Rust packages
  cargo install bat exa ripgrep tokei
  ## Install Clippy
  rustup add component clippy
  ## Install RustFmt
  rustup add component rustfmt
fi

##############################
# Go #########################
##############################
if !(type goenv > /dev/null 2>&1) && want_install "Go with goenv"; then
  ## Install goenv
  anyenv install goenv
  echo 'export GOPATH="$HOME/go"' >> ~/.profile
  echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.profile
  echo 'export GOENV_DISABLE_GOPATH=1' >> ~/.profile
  source ~/.profile
  goenv rehash
  ## Install Go
  goenv install $GO_VERSION
  goenv global $GO_VERSION
  ## Install Go packages
  go get github.com/motemen/ghq
  go get github.com/jesseduffield/lazygit
  go get github.com/jesseduffield/lazydocker
fi

##############################
# Node #######################
##############################
if !(type nodenv > /dev/null 2>&1) && want_install "Node with nodenv"; then
  ## Install nodenv
  anyenv install nodenv
  source ~/.profile
  nodenv rehash
  ## Install Node
  nodenv install $NODE_VERSION
  nodenv global $NODE_VERSION
  ## Install yarn
  curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
fi

##############################
# Neovim #####################
##############################
if [ $OS == "Mac" ]; then
  # brew install neovim
  brew install --HEAD neovim
elif [ $OS == "Linux" ]; then
  # sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
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
if !(type yarn > /dev/null 2>&1); then
  ~/.yarn/bin/yarn global add neovim
fi
## Install dein.nvim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm ./install.sh

##############################
# Language Server ############
##############################
## Python Language Server
pip install 'python-language-server[all]'
## Rust Language Server
rustup component add rls rust-analysis rust-src

##############################
# Starship ###################
##############################
# install powerline
pip install powerline-status
# install powerline patch
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
# install starship
cargo install starship

##############################
# Link dotfiles ##############
##############################
LINK=(".commit_template" ".gitconfig" ".hyper.js" 
      ".config/starship.toml" ".config/nvim" ".config/coc/extension/package.json"
      ".config/fish/config.fish")

for link in ${LINK[@]}
do
  echo $HOME/dotfiles/$link
  if [ ! -L $HOME/$link ]; then
    ln -snfv $HOME/dotfiles/$link $HOME/
  fi
done

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
echo -e "${F_BOLD}${C_WHITE}${C_GREEN4}Copy your ~/.ssh/id_rsa.pub, and add to Github.com${FORMAT}"

if [ $OS == "Linux" ]; then
  sudo apt autoremove
fi
