CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

export DIRENV_LOG_FORMAT=''

# NOTE: install rust packages with nix
# export PATH="$HOME/.local/share/cargo/bin:$PATH"

# NOTE: only for custom scripts
# install any external software uisng Nix only
export PATH="$HOME/.local/bin:$PATH"

# telling SSH how to access the gpg-agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# keystrokes
# xmodmap -e "keycode 64 = Mode_switch" # set Alt_l as the "Mode_switch"
# xmodmap -e "keycode 43 = h H Left H" # h
# xmodmap -e "keycode 44 = j J Down J" # j
# xmodmap -e "keycode 45 = k K Up K" # k
# xmodmap -e "keycode 46 = l L Right L" # l

# aliases
alias ls="exa"
alias l="ls -la --color=auto"
alias vi="nvim"
alias nixos-rebuild-switch="sudo nixos-rebuild --flake /home/$USER/dotfiles/hosts/$HOST switch"
alias nix-repl="nix repl nixpkgs"
alias spass="PASSWORD_STORE_DIR=${XDG_DATA_HOME}/shadow-password-store pass"
alias nnn="n"
alias N='sudo -E nnn -dH'

# XDG specification aliases
alias monerod=monerod --data-dir $XDG_DATA_HOME/bitmonero

# scripts
SCRIPTS_HOME=/home/$USER/dotfiles/scripts
mkdir -p ~/.local/bin

ln -sf $SCRIPTS_HOME/rreadlink ~/.local/bin/rreadlink
ln -sf $SCRIPTS_HOME/put ~/.local/bin/put
ln -sf $SCRIPTS_HOME/backup-keys ~/.local/bin/backup-keys
ln -sf $SCRIPTS_HOME/init-env/init-env ~/.local/bin/init-env
ln -sf $SCRIPTS_HOME/deep-clean ~/.local/bin/deep-clean
ln -sf $SCRIPTS_HOME/backup ~/.local/bin/backup
ln -sf $SCRIPTS_HOME/syncthing-apply-config ~/.local/bin/syncthing-apply-config
ln -sf $SCRIPTS_HOME/up-postgres/up-pg ~/.local/bin/up-pg
ln -sf $SCRIPTS_HOME/up-ch ~/.local/bin/up-ch
ln -sf $SCRIPTS_HOME/download-music ~/.local/bin/download-music
ln -sf $SCRIPTS_HOME/open-ports ~/.local/bin/open-ports

# modules
source $CONFIG_HOME/nnnrc.sh
