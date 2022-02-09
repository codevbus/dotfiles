#!/usr/local/bin/zsh

#GO stuff
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

#python stuff
export PYENV_ROOT=$HOME/.pyenv
export WORKON_HOME=$HOME/.virtualenvs

#PATH
export PATH=/usr/local/opt/gettext/bin:/usr/local/bin:/usr/local/sbin:/usr/local/go/bin:$HOME/scripts:$GOBIN:$PYENV_ROOT/bin:~/.emacs.d/bin:$HOME/.tfenv/bin:$PATH

# trigger caps remap
${HOME}/dotfiles/scripts/ctrl_remap.sh
