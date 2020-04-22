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
set -x RUSTC_WRAPPER sccache
# set RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

##############################
# fzf  #######################
##############################
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'

##############################
# starship ###################
##############################
eval (starship init fish)

##############################
# zoxide   ###################
##############################
zoxide init fish | source

##############################
# Alias ######################
##############################
## ghq
alias ghg 'ghq get'
alias ghl 'ghq list'
alias ghrm 'rm -rf (ghq list --full-path | fzf)'
alias ghcd 'cd (ghq list --full-path | fzf)'
## lazygit (Simple terminal UI for git commands)
alias lg 'lazygit'
## exa (Replacement for `ls` command)
alias exaf 'exa --long --all --group-directories-first --bytes --header --group --git'
alias exat 'exa --long --all --group-directories-first --bytes --header --group --git --tree --ignore-glob .git'
## cargo
alias rfmt 'cargo fmt'
alias cch 'cargo check --color=always'
alias clippy 'cargo clippy'
## Docker 
function ddc
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
end

function ddcr
    if [ -z $argv ]
        set name (basename $PWD)
    else
        set name $argv[1]
    end

    docker run --rm -v $PWD:/work --name $name -it (docker images --format "{{.Repository}}:{{.Tag}}" | fzf)
end
## fzf + bat
alias fpre 'fzf --preview "bat --color=always {}"'
alias fvim 'nvim (fpre)'
## pipenv
alias piid 'pipenv install --dev flake8 pylint isort mypy pysnooper pydocstyle bandit && pipenv install --dev --pre black'
