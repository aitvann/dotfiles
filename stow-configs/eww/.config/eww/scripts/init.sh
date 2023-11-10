#! /usr/bin/env bash
# rreadlink does not work when script is sourced
# and it seems to be what Hyprland is doing with `exec-once` statments
dir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

eww kill
eww daemon

$dir/../components/bar/init.sh
eww open bar
