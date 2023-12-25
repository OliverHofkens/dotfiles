#!/usr/bin/env bash

sketchybar --set "$NAME" icon="󰋊" label="$(df -H | grep -E '^(/dev/disk3s1).' | awk '{ printf ("%s\n", $5) }')"
