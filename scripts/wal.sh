#!/bin/bash

# Clear wal cache
wal -c

# generate colors palette, skip setting wallpaper
wal -i "$1" -n --vte

osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$(cat "$HOME/.cache/wal/wal")\""

$HOME/.yabairc