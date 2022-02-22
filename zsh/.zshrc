#!/usr/local/bin/zsh

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh
  zgen load zsh-users/zsh-completions
  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/common-aliases
  zgen oh-my-zsh plugins/compleat
  zgen oh-my-zsh plugins/dircycle
  zgen oh-my-zsh plugins/dirhistory
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/sudo
  # generate the init script from plugins above
  zgen save
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

#NVM specific config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#FZF
# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

# fzf + ag configuration
if _has fzf && _has rg; then
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git}/*" 2> /dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi

# aliases
if _has exa; then
  alias ls='exa'
fi

if _has batcat; then
  alias cat='batcat'
fi

alias myip='curl "https://api.ipify.org?format=json"'

# load zsh-syntax-highlighting last as specified
zgen load zsh-users/zsh-syntax-highlighting

#pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#virtualenvwrapper
source "${HOME}/.pyenv/versions/3.9.2/bin/virtualenvwrapper.sh"

# source local-specific config
source "${HOME}/.config/local.zsh"

# starship
eval "$(starship init zsh)"
