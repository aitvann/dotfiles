#! /usr/bin/env bash

# TODO: add `--replace` option to delete single old backup from `storage`
backup() {(
    set -e

    [ -z "$1" ] && echo "storage path must be set, aborting" && exit
    storage=$1

    source=$HOME/data
    filename=data-$(date +%Y%m%d%H%M%S)
    file=$storage/${filename}.tar.gz.gpg

    echo "backing up data from ${source} to ${file}"

    archive=$(mktemp -d /tmp/backup-${filename}-archive-XXXXXX)
    archive_file=$archive/${filename}.tar.gz
    tar -czf $archive_file -C $source .

    echo "encrypting backup"
    gpg --batch --output $file --symmetric $archive_file

    rm -r $archive

    set +e
)}
