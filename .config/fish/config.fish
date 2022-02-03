##############################
# config                     #
##############################
set fish_greeting ''
set -gx LC_ALL ja_JP.UTF-8
set -gx LC_TYPE ja_JP.UTF-8
set -gx LANG ja_JP.UTF-8
fish_add_path /usr/local/sbin
fish_add_path $HOME/.local/bin

##############################
# asdf                       #
##############################
source ~/.asdf/asdf.fish

##############################
# Python                     #
##############################
set -x PIPENV_VENV_IN_PROJECT 1

##############################
# Go                         #
##############################
set -x GOPATH $HOME/go
fish_add_path $GOPATH/bin

##############################
# Rust                       #
##############################
fish_add_path $HOME/.cargo/bin

##############################
# fzf                        #
##############################
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

##############################
# starship                   #
##############################
starship init fish | source

##############################
# zoxide                     #
##############################
zoxide init fish | source

##############################
# direnv                     #
##############################
set -x EDITOR nvim
direnv hook fish | source

##############################
# lima                       #
##############################
set -x LIMA_INSTANCE docker

##############################
# docker                     #
##############################
set -x DOKER_BUILDKIT=1

##############################
# Alias                      #
##############################
## ghq
alias ghg 'ghq get'
alias ghl 'ghq list'
## exa (Replacement for `ls` command)
alias exaf 'exa --long --all --group-directories-first --bytes --header --group --git'
alias exat 'exa --all --group-directories-first --group --git --tree --ignore-glob .git'
## cargo
alias rfmt 'cargo fmt'
alias cch 'cargo check --color=always'
alias clippy 'cargo clippy'
## fzf + bat
alias fpre 'fzf --preview "bat --color=always {}"'
alias fvim 'nvim (fpre)'
## pipenv
alias piid 'pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black'
## Docker
alias dc 'docker-compose'
