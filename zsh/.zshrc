#!/bin/zsh

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


# fzf integration
source <(fzf --zsh)

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/catppuccin_mocha.omp.json)"
