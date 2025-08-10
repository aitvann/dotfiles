# Configuration

This repo includes configuration for my hosts

Key features:

2.  Declarative encrypted BtrFs using [disko](https://github.com/nix-community/disko)
3.  Minimal NixOS configuration: as much as possible is moved to Home Manager
4.  Minimal Home Manager configuration: as much as possible is configured in
    [stow](https://www.gnu.org/software/stow/)-compatible way
5.  UWSM Hyprland
6.  Minimal NeoVim configuration:
    -   As much as possible is done with either LSP or TreeSitter
    -   Desktop notifications
    -   External (yet integrated with editor) file manager ([n³](https://github.com/jarun/nnn))
    -   External (yet integrated with editor) Git GUI
        ([Lazygit](https://github.com/jesseduffield/lazygit))
    -   External (yet integrated with editor) terminal
        ([Foot](https://github.com/jesseduffield/lazygit))

## Installation

**CAUTION**:

> DO NOT RUN DISKO ON A HOST WITH SIMILAR SETUP, USE LIVECD ON A FUTURE HOST INSTEAD !!!
>
> Filesystem and partition lables are used, expect conflicts

``` sh
# Could be: pluto, mars, jupiter, venus
NIXHOST=pluto
NIXUSER=general
curl "https://raw.githubusercontent.com/aitvann/dotfiles/refs/heads/master/hosts/${NIXHOST}/disko.nix" > disko.nix
echo -n 'main drive encryption password here' > /tmp/secret.key
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix
nixos-generate-config --show-hardware-config --no-filesystems --root /mnt
# Edit configuration.nix accordingly
sudo nixos-install --root /mnt --flake github:aitvann/dotfiles?dir=hosts#${NIXHOST}
nixos-enter --root /mnt/disko-install-root
chown -R ${NIXUSER}:users {.local,.snapshots}
su - ${NIXUSER}
# Insert cd with secrets
import-secrets ~/secrets.tar.gpg --password "password here"
restic-jupiter restore -t ~ latest:home/${NIXUSER}
mkdir -p {~/.config/mpd,~/.config/gtk-2.0}
reboot
```

## Workstation

"Workstation" is a configuration shared between two hosts: mars (laptop), pluto (pc)

### Change GTK Theme

2.  Add theme package to `home.packages`
3.  Some files might need to be deleted if they point to `/nix/store`, otherwise `nwg-look` won't
    apply the changes:
    `rm {~/.local/share/icons/default/index.theme,~/.config/xsettingsd/xsettingsd.conf,~/.config/gtk-2.0/gtkrc,~/.config/gtk-3.0/settings.ini,~/.config/gtk-4.0/settings.ini}`
4.  Select and apply themes using `nwg-look` tool
5.  Run `systemctl --user restart xsettingsd.service`
6.  Run `apply-config gtk` script to copy GTK configuration files to the repo

### Change QT Theme

1.  Add theme package to `home.packages`
2.  Set `QT_QPA_PLATFORMTHEME`, `QT_STYLE_OVERRIDE` in `uwsm/env`

### Change Syncthing Configuration

1.  Do all the changes in a web GUI
2.  Run `apply-config syncthing-${HOST}` to copy new configuration to the repo
