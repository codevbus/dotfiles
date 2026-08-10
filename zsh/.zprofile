#!/bin/zsh

# File: ~/.zprofile

# SSH agent is managed by the systemd user service (ssh-agent.socket), with a
# stable socket at $XDG_RUNTIME_DIR/ssh-agent.socket exported via
# ~/.config/environment.d/ssh-agent.conf (stow pkg `systemd`). All user services
# — including the Emacs daemon — inherit SSH_AUTH_SOCK from there.
#
# Do NOT spawn a shell-local ssh-agent here: setting SSH_AGENT_PID trips the
# shipped unit's `ConditionEnvironment=!SSH_AGENT_PID` and blocks it, which is
# the exact split that left the Emacs daemon unable to reach the agent.
# Load keys via `AddKeysToAgent yes` in ~/.ssh/config, or `ssh-add` on demand.
