#!/bin/zsh

#GO stuff
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#python stuff
export PYENV_ROOT=$HOME/.pyenv
export WORKON_HOME=$HOME/.virtualenvs

#gcloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$GOBIN:$PYENV_ROOT/bin:~/.emacs.d/bin:$HOME/.tfenv/bin:/opt/homebrew/bin:$HOME/.local/bin:$PATH
. "$HOME/.cargo/env"
