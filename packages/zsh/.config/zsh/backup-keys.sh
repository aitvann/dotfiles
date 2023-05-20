#! /usr/bin/env bash

# backups keys, passwords then encrypts it and uploads to storage
backup-keys() {(
    set -e

    filename=keys-$(date +%Y%m%d%H%M%S)
    scope=$(mktemp -d /tmp/backup-${filename}-XXXXXX)
    cd $scope
    mkdir keys

    echo "exporting gpg keys..."
    gpg --export --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.pub.asc
    gpg --export-secret-keys --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.priv.asc
    gpg --export-secret-subkeys --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.spriv.asc
    gpg --export-ownertrust > keys/ownertrust.txt

    echo "exporting password store..."
    mkdir keys/password-store
    cp -r $PASSWORD_STORE_DIR keys/password-store

    echo "encrypting keys..."
    tar -cf keys.tar -C keys/ .
    gpg --batch --output ${filename}.tar.gpg --symmetric keys.tar

    echo "pushing to storage..."
    # rclone copy "$filename" storage:./keys/
    mv ${filename}.tar.gpg ~/data/keys/

    cd -
    rm -r $scope

    set +e
)}
