CONFIG_HOME=$XDG_CONFIG_HOME/zsh

# NOTE: install rust packages with nix
# export PATH="$HOME/.local/share/cargo/bin:$PATH"

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
alias top="btop"
alias nnn="n"
alias N='sudo -E nnn -dH'
alias spass="PASSWORD_STORE_DIR=${XDG_DATA_HOME}/shadow-password-store pass"
alias restic-jupiter="restic --repo 'sftp:jupiter:/mnt/backup-storage' --password-command 'pass jupiter-backup'"
alias nixos-rebuild-switch="sudo nixos-rebuild --flake /home/${USER}/dotfiles#${HOST} switch"
alias hm-rebuild-switch="home-manager switch --flake /home/${USER}/dotfiles#${HOST}-${USER}"
alias user-repl='nix repl ~/dotfiles/hosts#homeConfigurations."$HOST-$USER"'
# pkgs = pluto.config.home-manager.extraSpecialArgs.inputs.nixpkgs.legacyPackages.x86_64-linux
alias host-repl='nix repl ~/dotfiles/hosts#nixosConfigurations."$HOST"'
# :lf .#
# pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux
alias nix-repl='nix repl nixpkgs'

# XDG
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias monerod=monerod --data-dir "${XDG_DATA_HOME}/monero/blockchain"

# scripts
SCRIPTS_HOME=/home/$USER/dotfiles/scripts
mkdir -p ~/.local/bin
# using `ln -T`so we dont get `up-postgres` inside `up-postgres` after multiple runs
command ls $SCRIPTS_HOME | xargs -I {} ln -T -s $SCRIPTS_HOME/{} ~/.local/bin/{} 2> /dev/null

# modules
source $CONFIG_HOME/nnnrc.sh
