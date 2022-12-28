#! /usr/bin/env bash

init-env() {(
    set -e

    flake_target=flake.nix
    shell_target=shell.nix

    case "$2" in
        "--flake" | "" ) use_shell=false;;
        "--shell" ) use_shell=true;;
        * )
            echo "invalid argument: expected 'flake' or 'shell'"
            exit 1
        ;;
    esac
        
    if [ -f "$flake_target" ] || [ -f "$shell_target" ]; then
	      echo "environment is already set up"
        exit 1
    fi
        
    if [ "$use_shell" = true ]; then
        shell="${ZDOTDIR}/init-env/default-shells/${1}.nix"
        if [ ! -f "$shell" ]; then
            echo "no shell environment for ${1}"
            exit 1
        fi
        cp $shell $shell_target
        echo "source_up_if_exists" > .envrc
        echo "use nix" >> .envrc
    else
        if [ $(git rev-parse --is-inside-work-tree &> /dev/null)$? != 0 ]; then 
            echo "git reposetory is required"
            exit 1
        fi

        if [ $(git diff --cached --exit-code 1> /dev/null)$? != 0 ]; then 
            echo "git index is not empty"
            exit 1
        fi
        
        flake="${ZDOTDIR}/init-env/default-flakes/${1}.nix"
        if [ ! -f "$flake" ]; then
            echo "no flake environment for ${1}"
            exit 1
        fi

        cp $flake $flake_target
        git add $flake_target
        git commit -m "chore: add flake environment"
        echo "source_up_if_exists" > .envrc
        echo "use flake" >> .envrc
    fi
    
    # TODO: more generic solution
    # if [ $1 = "rust" ]; then
    #     echo "watch_file rust-toolchain" >> .envrc
    # fi

    direnv allow

    set +e
)}
