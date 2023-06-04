#! /usr/bin/env bash

__deep-clean-docker() {(
    docker container prune -f
    docker volume prune -f
    docker image prune -af
)}

__deep-clean-cargo() {(
    find . -type f -name 'Cargo.toml' | parallel cargo clean --manifest-path {}
    cargo cache -a
)}

__deep-clean-nix() {(
    nix-collect-garbage -d
    nix profile wipe-history
    nix store gc
    nix store optimise
)}

__sudo-deep-clean-nix() {(
    sudo nix-collect-garbage -d
    nix profile wipe-history
    nix store gc
    nix store optimise
)}

deep-clean() {(
    set -e

    __deep-clean-docker &
    __deep-clean-cargo &
    __deep-clean-nix

    set +e
)}

sudo-deep-clean() {(
    set -e

    __deep-clean-docker &
    __deep-clean-cargo &
    __sudo-deep-clean-nix

    set +e
)}
