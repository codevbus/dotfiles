#!/bin/sh
# Wayland power menu via fuzzel. Shared by Hyprland (Mod+P / waybar power button).
# No wlogout dependency — fuzzel is already used as the launcher.
chosen=$(printf '%s\n' ' Lock' ' Logout' ' Suspend' ' Reboot' ' Shutdown' \
    | fuzzel --dmenu --prompt "power: ")

case "$chosen" in
    *Lock)     swaylock ;;
    *Logout)   uwsm stop 2>/dev/null \
                 || hyprctl dispatch 'hl.dsp.exit()' 2>/dev/null \
                 || loginctl terminate-session "${XDG_SESSION_ID}" ;;
    *Suspend)  systemctl suspend ;;
    *Reboot)   systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
esac
