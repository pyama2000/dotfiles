# Setting for greeting message
set fish_greeting

# Setting for pyenv
## Set enviroment valeue `PYENV_ROOT`
set -gx PYENV_ROOT $HOME/.anyenv/envs/pyenv

## Set (pyenv init - fish)
set -gx PATH '/home/yamashita/.anyenv/envs/pyenv/shims' $PATH
set -gx PYENV_SHELL fish
source '/home/yamashita/.anyenv/envs/pyenv/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end

## Set pyenv virtualenv
status --is-interactive; and source (pyenv init - | psub)
status --is-interactive; and source (pyenv virtualenv-init - | psub)

# Setting for goenv
set -gx GOENV_ROOT $HOME/.anyenv/envs/goenv

# Setting for golang
set -gx GOPATH $HOME/go
