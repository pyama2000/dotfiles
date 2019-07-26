set fish_greeting ''

##############################
# anyenv #####################
##############################
set -gx ANYENV_ROOT $HOME/.anyenv
set PATH $ANYENV_ROOT/bin $PATH
anyenv init - fish | source


##############################
# Python #####################
##############################
## pipenv
set -gx PIPENV_VENV_IN_PROJECT 1

##############################
# Go #########################
##############################
## Go
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH
## goenv
set -gx GOENV_DISABLE_GOPATH 1

##############################
# Rust #######################
##############################
set -gx PATH $HOME/.cargo/bin $PATH
# set RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

##############################
# fzf  #######################
##############################
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

##############################
# Alias ######################
##############################
## Git
alias ga 'git add .'
alias gc 'git commit'
alias gco 'git checkout'
## ghq
alias ghg 'ghq get'
alias ghl 'ghq list'
alias ghrm 'rm -rf (ghq root)/(ghq list | fzf)'
alias ghcd 'cd (ghq root)/(ghq list | fzf)'
## lazygit (Simple terminal UI for git commands)
alias lg 'lazygit'
## exa (Replacement for `ls` command)
alias exaf 'exa --long --all --group-directories-first --bytes --header --links --git'
## cargo
alias rfmt 'cargo +nightly fmt'
alias cch 'cargo check --color=always'
alias clippy 'cargo +nightly clippy'
## exa
alias exaf 'exa --long --all --group-directories-first --bytes --header --links --git'
## Docker 
alias ddc 'docker run -v $PWD:/work -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)'
alias ddcr 'docker run --rm -v $PWD:/work -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)'
alias atkk 'docker run -v $PWD:/work -it atkk_dev:latest /usr/bin/fish'
alias atkkr 'docker run --rm -v $PWD:/work -it atkk_dev:latest /usr/bin/fish'
## fzf + bat
alias fpre 'fzf --preview "bat --color=always {}"'
alias fvim 'nvim (fpre)'
## pipenv
alias piid 'pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black'
