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

# Binds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Aliases
alias ls='eza'
alias cat='bat'
alias history='history 0'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


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

# zsh fzf
eval "$(fzf --zsh)"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# source local.zsh for local overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/catppuccin_mocha.omp.json)"
