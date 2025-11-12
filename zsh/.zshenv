#!/bin/zsh

#python
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

#Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#config
export XDG_CONFIG_HOME=$HOME/.config
export EMACSDIR=$XDG_CONFIG_HOME/emacs

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$HOME/.local/bin:$GOBIN:$HOME/.tfenv/bin:/opt/cuda/lib:$HOME/.local/share/nvim/mason/bin:/opt/cuda/bin/:$XDG_CONFIG_HOME/emacs/bin:$PATH
