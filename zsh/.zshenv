#!/usr/local/bin/zsh

#GO stuff
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$GOBIN:$HOME/.config/emacs/bin:$HOME/.tfenv/bin:$PATH

. "$HOME/.cargo/env"
