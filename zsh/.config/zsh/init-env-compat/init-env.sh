#! /usr/bin/env bash

flake_target=flake.nix
shell_target=shell.nix

init-env() {(
    set -e

    if [ -f "$flake_target" ] || [ -f "$shell_target" ]; then
	      echo "environment is already set up"
        exit 1
    fi
        
    if [ -f ".git" ]; then
        echo "git reposetory is required"
        exit 1
    fi

    if [ $(git diff --cached --exit-code 1> /dev/null)$? != 0 ]; then 
        echo "git index is not empty"
        exit 1
    fi

    is_gitrepo=$(test .git)
    flake="${ZDOTDIR}/init-env/default-env/${1}.nix"
    shell="${ZDOTDIR}/init-env/default-shell.nix"
    if [ ! -f "$flake" ]; then
        echo "no environment for ${1}"
        exit 1
    fi

    cp $flake $flake_target
    git add $flake_target
    git commit -m "chore: track flake.nix for ${1} environment"
    nix flake lock
    cp $shell $shell_target
    echo "use nix" >> .envrc
    direnv allow

    echo "don't forget to run: git reset HEAD^"

    set +e
)}
