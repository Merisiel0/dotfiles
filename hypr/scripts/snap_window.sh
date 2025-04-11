#!/bin/bash

# get monitor information
active_window=$(hyprctl activewindow -j)
monitor=$(echo "$active_window" | jq -r '.monitor')
monitor_info=$(hyprctl monitors -j | jq ".[] | select(.id == $monitor)")

# get monitor dimensions
mon_x=$(echo "$monitor_info" | jq -r '.x')
mon_y=$(echo "$monitor_info" | jq -r '.y')

scale=$(echo $monitor_info | jq -r '.scale')

width=$(echo $monitor_info | jq -r '.width')
scaled_width=$(echo "$width / $scale" | bc)

height=$(echo $monitor_info | jq -r '.height')
scaled_height=$(echo "$height / $scale" | bc)

# apply changes
target=$1

case "$target" in
  "left")
    x=$mon_x
    y=$mon_y
    w=$((scaled_width / 2))
    h=$scaled_height
    ;;
  "right")
    x=$((mon_x + scaled_width / 2))
    y=$mon_y
    w=$((scaled_width / 2))
    h=$scaled_height
    ;;
  "top-left")
    x=$mon_x
    y=$mon_y
    w=$((scaled_width / 2))
    h=$((scaled_height / 2))
    ;;
  "top-right")
    x=$((mon_x + scaled_width / 2))
    y=$mon_y
    w=$((scaled_width / 2))
    h=$((scaled_height / 2))
    ;;
  "bottom-left")
    x=$mon_x
    y=$((mon_y + scaled_height / 2))
    w=$((scaled_width / 2))
    h=$((scaled_height / 2))
    ;;
  "bottom-right")
    x=$((mon_x + scaled_width / 2))
    y=$((mon_y + scaled_height / 2))
    w=$((scaled_width / 2))
    h=$((scaled_height / 2))
    ;;
  *)
    echo "Usage: [left|right|top-left|top-right|bottom-left|bottom-right]"
    exit 1
    ;;
esac

echo $x
echo $y

hyprctl dispatch moveactive exact $x $y
hyprctl dispatch resizeactive exact $w $h
