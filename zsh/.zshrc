#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

if type brew &>/dev/null; then
  # Homebrew managed shell completions: https://docs.brew.sh/Shell-Completion
  # `autoload -Uz compinit; compinit` handled by antidote plugin:`belak/zsh-utils path:completion`.
  fpath+=`brew --prefix`/share/zsh/site-functions
fi

# hist config                                                                                                     │
alias history="history 1"
## hist file location
export HISTFILE=$HOME/.zsh_history
# the detailed meaning of the below three variable can be found in `man zshparam`.                                │
export HISTSIZE=1000000   # the number of items for the internal history list                                     │
export SAVEHIST=1000000   # maximum number of items for the history file
export HISTTIMEFORMAT="[%F %T] "

# The meaning of these options can be found in man page of `zshoptions`.                                          │
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list                                    │
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command                                                        │
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks                                                            │
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution                      │
setopt EXTENDED_HISTORY  # record command start time

# Binds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Aliases
alias ls='eza'
alias cat='bat'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf integration
source <(fzf --zsh)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
PATH="$PATH:$(pyenv root)/shims:/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin"
