ZSH_DATA=$XDG_DATA_HOME/zsh
ZSH_PLUGINS=$ZSH_DATA/plugins

# Nix related stuff
fpath+=(/etc/profiles/per-user/$USER/share/zsh/site-functions/)
fpath+=(/run/current-system/sw/share/zsh/site-functions/)

function load-carapace() {
    autoload -U compinit -d $ZSH_DATA/.zcompdump && compinit -d $ZSH_DATA/.zcompdump

    export CARAPACE_BRIDGES='zsh'
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
    source <(carapace _carapace)

    # # completion without fzf-tab
    # zmodload zsh/complist
    #
    # bindkey '^I' menu-select
    # bindkey "$terminfo[kcbt]" reverse-menu-complete
    # # make completions usable even kwithout fzf-tab
    # zstyle ':completion:*' menu select
    # zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

    compinit -d $ZSH_DATA/.zcompdump
}

function load-fzf-tab() {
    zsh-defer -12 source $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh

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

source $ZSH_PLUGINS/zsh-defer/zsh-defer.plugin.zsh

zsh-defer -12 load-carapace
zsh-defer -12 load-fzf-tab
# breaks `select-word-style`, does not worth it
# zsh-defer -12 source $ZSH_PLUGINS/zsh-autopair/autopair.zsh
zsh-defer -12 source $ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# should always be the last to load
zsh-defer -12 source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

export HISTSIZE="100000"
export SAVEHIST=$HISTSIZE
export HISTFILE=$ZSH_DATA/.zsh_history

# show hidden files
setopt globdots
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
zsh-defer -12 eval "$(atuin init zsh)"
export _ZL_MATCH_MODE=1
export _ZL_DATA=$ZSH_DATA/.zlua
zsh-defer -12 eval "$(z --init zsh)"

# key bindings
bindkey '^[[1;5D' backward-word # <Ctrl-Left>
bindkey '^[[1;5C' forward-word # <Ctrl-Right>
bindkey '^[[3~' delete-char # <Delete>
bindkey '^[[3;5~' kill-word # <Ctrl-Delete>
bindkey '' backward-kill-word # <Ctrl-Backspace>

autoload -U select-word-style
select-word-style bash

# HACK: fix chpwd hooks not running on sturtup
# https://gist.github.com/laggardkernel/b2cbc937aa1149530a4886c8bcc7cf7c
function _self_destruct_hook {
  local f
  for f in ${chpwd_functions}; do
    "$f"
  done

  # remove self from precmd
  precmd_functions=(${(@)precmd_functions:#_self_destruct_hook})
  builtin unfunction _self_destruct_hook
}

add-zsh-hook precmd _self_destruct_hook

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

source $ZDOTDIR/session.sh

# code belove require BABASHKA_CLASSPATH to be set and scripts to be in-place

# write current location
function update_cwd_file() {
  current_pid=$(echo $$)
  bb -m hypr-current-location write zsh $current_pid $PWD
}
add-zsh-hook -Uz chpwd update_cwd_file
