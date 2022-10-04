ZSH_CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

# telling SSH how to access the gpg-agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# aliases
alias l="ls -la"

# key bindings
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '' backward-kill-word

# scripts
source "$ZSH_CONFIG_HOME/put.sh"
source "$ZSH_CONFIG_HOME/backup-keys.sh"
