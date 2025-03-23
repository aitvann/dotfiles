CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

export DIRENV_LOG_FORMAT=''

# NOTE: install rust packages with nix
# export PATH="$HOME/.local/share/cargo/bin:$PATH"

# NOTE: only for custom scripts
# install any external software uisng Nix only
export PATH="$HOME/.local/bin:$PATH"

export BABASHKA_CLASSPATH="$HOME/.local/bin"

# telling SSH how to access the gpg-agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# make NeoVim a man pager
export MANPAGER='nvim +Man!'

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
alias nixos-rebuild-switch="sudo nixos-rebuild --flake /home/${USER}/dotfiles/hosts#${HOST} switch"
alias hm-rebuild-switch="home-manager switch --flake /home/${USER}/dotfiles/hosts#${HOST}-${USER}"
alias spass="PASSWORD_STORE_DIR=${XDG_DATA_HOME}/shadow-password-store pass"
alias restic-jupiter="restic --repo 'sftp:jupiter:/mnt/backup-storage' --password-command 'pass jupiter-backup'"
alias nnn="n"
alias N='sudo -E nnn -dH'
# consider nix --extra-experimental-features repl-flake repl ".#nixosConfigurations.\"$NAME\""
# https://discourse.nixos.org/t/use-repl-to-inspect-a-flake/28275
alias nix-repl="nix repl nixpkgs"

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
