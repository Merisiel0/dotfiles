#!/bin/bash

# if in the special workspace,
# moves the active window to the current workspace

hyprctl dispatch movetoworkspace $(hyprctl activeworkspace | grep -oP 'ID \K\d+')