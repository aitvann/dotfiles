#! /usr/bin/env bash

# backups keys, passwords then encrypts it and uploads to storage
backup-keys() {(
    set -e

    echo "exporting gpg keys..."
    mkdir keys
    gpg --export --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.pub.asc
    gpg --export-secret-keys --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.priv.asc
    gpg --export-secret-subkeys --armor 3C47594A515D2C70B8EF97781AA36C4408AB6ACE > keys/aitvann.spriv.asc
    gpg --export-ownertrust > keys/ownertrust.txt

    echo "exporting password store..."
    mkdir keys/password-store
    cp -r /home/aitvann/.password-store keys/password-store

    echo "encrypting keys..."
    tar -cf keys.tar -C keys/ .
    rm -r keys
    echo -n "Password: "
    read -s password
    echo
    filename=keys-$(date +%Y%m%d%H%M%S).tar.gpg
    gpg --batch --output "$filename" --passphrase "$password" --symmetric keys.tar
    unset "password"
    rm -r keys.tar

    echo "pushing to storage..."
    # rclone copy "$filename" storage:./keys/
    # rm "$filename"
    mv "$filename" ~/data/keys/

    set +e
)}
