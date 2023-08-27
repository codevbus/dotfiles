#!/bin/zsh

#python
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

#Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#emacs
export EMACSDIR=$HOME/.emacs.d

#config
export XDG_CONFIG_HOME=$HOME/.config

#editor
export EDITOR=$(which nvim)

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$HOME/.local/bin:$GOBIN:$PYENV_ROOT/bin:$PYENV_ROOT/shims:~/.emacs.d/bin:$HOME/.tfenv/bin:/opt/cuda/lib:$HOME/.local/share/nvim/mason/bin:$PATH
