#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -a) == *"Linux"* ]]; then
    setxkbmap -option ctrl:nocaps
    xcape -e 'Control_L=Escape'
else
    echo "Not a Linux OS!"
    exit 1
fi
