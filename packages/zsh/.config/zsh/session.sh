CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

export DIRENV_LOG_FORMAT=''

# NOTE: install rust packages with nix
# export PATH="$HOME/.local/share/cargo/bin:$PATH"

# NOTE: install everything uisng only nix
# export PATH="$HOME/.local/bin:$PATH"

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

# XDG specification aliases
alias monerod=monerod --data-dir $XDG_DATA_HOME/bitmonero

# scripts
SCRIPTS_HOME=/home/$USER/dotfiles/scripts

alias put=$SCRIPTS_HOME/put
alias backup-keys=$SCRIPTS_HOME/backup-keys
alias init-env=$SCRIPTS_HOME/init-env/init-env
alias deep-clean=$SCRIPTS_HOME/deep-clean
alias backup=$SCRIPTS_HOME/backup
alias syncthing-apply-config=$SCRIPTS_HOME/syncthing-apply-config
alias up-pg=$SCRIPTS_HOME/up-postgres/up-pg
alias up-ch=$SCRIPTS_HOME/up-ch
