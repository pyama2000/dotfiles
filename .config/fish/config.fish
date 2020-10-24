##############################
# config                     #
##############################
set fish_greeting ''
set -gx LC_ALL ja_JP.UTF-8
set -gx LC_TYPE ja_JP.UTF-8
set -gx LANG ja_JP.UTF-8

##############################
# anyenv                     #
##############################
set -gx ANYENV_ROOT $HOME/.anyenv
set PATH $ANYENV_ROOT/bin $PATH
anyenv init - fish | source


##############################
# Python                     #
##############################
set -gx PIPENV_VENV_IN_PROJECT 1

##############################
# Go                         #
##############################
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH
set -gx GOENV_DISABLE_GOPATH 1

##############################
# Rust                       #
##############################
set -gx PATH $HOME/.cargo/bin $PATH
set -x RUSTC_WRAPPER sccache

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
eval (direnv hook fish)

##############################
# Alias                      #
##############################
## ghq
alias ghg 'ghq get'
alias ghl 'ghq list'
## exa (Replacement for `ls` command)
alias exaf 'exa --long --all --group-directories-first --bytes --header --group --git'
alias exat 'exa --long --all --group-directories-first --bytes --header --group --git --tree --ignore-glob .git'
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
