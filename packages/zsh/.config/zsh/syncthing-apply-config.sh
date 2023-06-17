#! /bin/sh

syncthing-apply-config() {(
    set -e

    src=$XDG_CONFIG_HOME/syncthing/config.xml
    dst=/home/$USER/dotfiles/packages/syncthing/.config/syncthing/config.xml

    test -L $src && echo "config is already up to date" && exit

    # TODO: find workaround to go with git-crypt
    # dst_changes=$(git diff $dst)
    # test -z "$changes" && echo "changes from dotfiles config can not be overwritten" && exit

    cp -f $src $dst
    echo "dotfiles config replaced with up to date version"

    set +e
)}
