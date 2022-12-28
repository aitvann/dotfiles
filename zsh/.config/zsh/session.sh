CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

export DIRENV_LOG_FORMAT=''

# TODO: install rust packages with nix
# export PATH="$HOME/.local/share/cargo/bin:$PATH"

# TODO: install everything uisng only nix
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

# scripts
source "$CONFIG_HOME/put.sh"
source "$CONFIG_HOME/backup-keys.sh"
source "$CONFIG_HOME/init-env/init-env.sh"
