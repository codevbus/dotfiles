#!/bin/zsh

# aliases
#if _has exa; then
alias ls='eza'
#fi
#
#if _has batcat; then
alias cat='bat'
#fi

alias history='fc -l 1'

zstyle ':antidote:bundle' use-friendly-names on

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

alias myip='curl -s "https://api.ipify.org?format=json" | jq -r .ip | tee >(xclip -selection clipboard)'

#pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# source local-specific config (machine-specific paths/aliases live here)
source "${HOME}/.config/local.zsh"

# hist config
# https://www.reddit.com/r/zsh/comments/13jg6ru/nomyzsh_killed_my_history/jkg04xo/
zopts_hist=(
  bang_hist
  extended_history
  hist_expire_dups_first
  hist_find_no_dups
  hist_ignore_all_dups
  hist_ignore_dups
  hist_ignore_space
  hist_reduce_blanks
  hist_save_no_dups
  hist_verify
  inc_append_history
  NO_hist_beep
  NO_share_history
)
setopt $zopts_hist

## hist file location
export HISTFILE=$HOME/.zsh_history
# the detailed meaning of the below three variable can be found in `man zshparam`.
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file
export HISTTIMEFORMAT="[%F %T] "

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/catppuccin_mocha.omp.json)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
