#!/usr/local/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# aliases
#if _has exa; then
alias ls='exa'
#fi
#
#if _has batcat; then
alias cat='bat'
#fi

alias history='fc -l 1'

zstyle ':antidote:bundle' use-friendly-names on
zstyle ':ohmyzsh:plugins:ssh-agent' agent-forwarding yes identities id_rsa git_rsa

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

alias myip='curl "https://api.ipify.org?format=json"'

#pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# source local-specific config
source "${HOME}/.config/local.zsh"

alias luamake=/home/mike/build/lua-language-server/3rd/luamake/luamake

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
