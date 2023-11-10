#! /usr/bin/env bash

dir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

$dir/system/init.sh
