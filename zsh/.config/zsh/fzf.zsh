export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export FZF_DEFAULT_OPTS='--height 40 --layout=reverse --multi --preview "bat --color=always --style='numbers,header' {}" --color="border:grey"'

source "/usr/share/fzf/completion.zsh"
source "$HOME/.config/zsh/fzf-key-bindings.zsh"

