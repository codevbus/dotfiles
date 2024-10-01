#!/usr/bin/zsh

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
PATH="$PATH:$(pyenv root)/shims:/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin"
