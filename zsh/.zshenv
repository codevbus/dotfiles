#!/usr/bin/zsh

#GO stuff
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#python stuff
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$HOME/.local/bin:$GOBIN:$PYENV_ROOT/bin:$PYENV_ROOT/shims:~/doom-emacs/bin:$HOME/.tfenv/bin:$PATH
