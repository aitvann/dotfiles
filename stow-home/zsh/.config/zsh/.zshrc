source $XDG_CONFIG_HOME/sh/.shrc

ZSH_CONFIG=$XDG_CONFIG_HOME/zsh
ZSH_DATA=$XDG_DATA_HOME/zsh
ZSH_PLUGINS=$ZSH_DATA/plugins

# Show hidden files
setopt globdots
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

export HISTSIZE="100000"
export SAVEHIST=$HISTSIZE
export HISTFILE=$ZSH_DATA/.zsh_history

# Use Emacs mode (no Vi mode) (no Normal mode on Esc kye press)
bindkey -e

# Key bindings
bindkey '^[[1;5D' backward-word # <Ctrl-Left>
bindkey '^[[1;5C' forward-word # <Ctrl-Right>
bindkey '^[[3~' delete-char # <Delete>
bindkey '^[[3;5~' kill-word # <Ctrl-Delete>
bindkey '' backward-kill-word # <Ctrl-Backspace>

autoload -U select-word-style
select-word-style bash

function load-zsh-autocomplete() {
    plug_path=$ZSH_PLUGINS/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    [[ -f $plug_path ]] || return 1
    source $plug_path

    zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 2 )) )'

    # Completion without fzf-tab. Also required for recent paths completion
    bindkey              '^I'         menu-complete
    bindkey "$terminfo[kcbt]" reverse-menu-complete
    bindkey              '^I' menu-select
    bindkey "$terminfo[kcbt]" menu-select
}

function load-fzf-tab() {
    plug_path=$ZSH_PLUGINS/fzf-tab/fzf-tab.zsh
    [[ -f $plug_path ]] || return 1

    # zsh-utocomplete is not loaded
    if (( ! ${+_autocomplete__func_opts} )); then
        autoload -U compinit -d $ZSH_DATA/.zcompdump && compinit -d $ZSH_DATA/.zcompdump
    fi

    source $plug_path

    zmodload zsh/complist

    # disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false
    zstyle ':completion:*:git-commit:*' sort false
    # set descriptions format to enable group support
    # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
    zstyle ':completion:*:descriptions' format '[%d]'
    # set list-colors to enable filename colorizing
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
    # zstyle ':completion:*' menu no
    # preview directory's content with eza when completing cd
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    # preview service's status
    zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
    zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'
    # custom fzf flags
    # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
    zstyle ':fzf-tab:*' fzf-flags -i --bind=ctrl-e:abort
    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'
}

function load-carapace() {
    command -v carapace >/dev/null || return 1

    # zsh-utocomplete is not loaded
    if (( ! ${+_autocomplete__func_opts} )); then
        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    fi

    export CARAPACE_BRIDGES='zsh,bash,cobra'
    # Carapace's implementation relies on channels and thus does not work with flakes
    export CARAPACE_EXCLUDES='nix'
    source <(carapace _carapace)

    # Completion without fzf-tab
    # zmodload zsh/complist
    #
    # bindkey '^I' menu-select
    # bindkey "$terminfo[kcbt]" reverse-menu-complete
    # # make completions usable even kwithout fzf-tab
    # zstyle ':completion:*' menu select
    # zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
}

function load-zsh-abbr() {
    plug_path=$ZSH_PLUGINS/zsh-abbr/zsh-abbr.zsh
    [[ -f $plug_path ]] || return 1
    source $plug_path

    # Use with journalctl
    abbr -S --quiet --global jnav="-a -o json --output-fields=MESSAGE,PRIORITY,_PID,SYSLOG_IDENTIFIER,_SYSTEMD_UNIT | lnav"
}

function load-autopair() {
    plug_path=$ZSH_PLUGINS/zsh-autopair/autopair.zsh
    [[ -f $plug_path ]] || return 1
    source $plug_path
}

function load-fast-syntax-highlighting() {
    plug_path=$ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    [[ -f $plug_path ]] || return 1
    source $plug_path
}

function load-autosuggestions() {
    plug_path=$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
    [[ -f $plug_path ]] || return 1
    source $plug_path
}

function load-starship() {
    command -v starship >/dev/null || return 1

    eval "$(starship init zsh)"
}

function load-atuin() {
    command -v atuin >/dev/null || return 1

    eval "$(atuin init zsh)"
}

function load-zlua() {
    command -v z >/dev/null || return 1

    export _ZL_MATCH_MODE=1
    export _ZL_DATA=$ZSH_DATA/.zlua
    zsh-defer -12 eval "$(z --init zsh)"
}

source $ZSH_PLUGINS/zsh-defer/zsh-defer.plugin.zsh

# Both should be loaded non-lazily to work together
# load-zsh-autocomplete
# load-fzf-tab

zsh-defer -12 load-zsh-autocomplete
# zsh-defer -12 load-fzf-tab

load-starship
zsh-defer -12 load-atuin
zsh-defer -12 load-zlua
zsh-defer -12 load-carapace
zsh-defer -12 load-zsh-abbr
zsh-defer -12 load-autopair
zsh-defer -12 load-fast-syntax-highlighting
# should always be the last to load
zsh-defer -12 load-autosuggestions

# Edit command line in NeoVim
autoload -Uz edit-command-line
zle -N edit-command-line
function kitty_scrollback_edit_command_line() { 
  local VISUAL="${XDG_DATA_HOME}/nvim/site/pack/hm/start/kitty-scrollback.nvim/scripts/edit_command_line.sh"
  zle edit-command-line
  zle kill-buffer
}
zle -N kitty_scrollback_edit_command_line
bindkey '^g' kitty_scrollback_edit_command_line

# OSC-7
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}
function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

# OSC-133;A
precmd() {
    print -Pn "\e]133;A\e\\"
}

if [ -d "${ZSH_CONFIG}/modules" ]; then
    setopt local_options no_nomatch 2>/dev/null
    for file in "${ZSH_CONFIG}/modules"/*; do
        [ -f "$file" ] && . $file
    done
    setopt local_options nomatch 2>/dev/null
fi
