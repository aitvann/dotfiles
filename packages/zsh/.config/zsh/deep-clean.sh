#! /usr/bin/env bash

# TODO: run all of it in parallel
deep-clean() {(
    set -e

    docker container prune -f
    docker volume prune -f
    docker image prune -af

    # TODO: run in parallel
    for f in $HOME/**/Cargo.toml; do cargo clean --manifest-path $f; done
    cargo cache -a

    nix-store --gc
    nix-store --optimise

    set +e
)}
