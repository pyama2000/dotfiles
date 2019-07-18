set fish_greeting ''
set -x PYENV_ROOT (anyenv root)/envs/pyenv
set -x NODENV_ROOT (anyenv root)/envs/nodenv
set -x PATH $NODENV_ROOT/bin $PATH
set -x PATH $NODENV_ROOT/shims $PATH
set -x GOENV_ROOT (anyenv root)/envs/goenv
set -x PATH $GOENV_ROOT/bin $PATH
set -x PATH $GOENV_ROOT/shims $PATH
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH
set -x GOENV_DISABLE_GOPATH 1
