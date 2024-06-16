ZSH_DATA=$XDG_DATA_HOME/zsh

export ZPLUG_HOME=$ZSH_DATA/zplug

ZPLUG_SRC=$ZSH_DATA/zplug_src
if [[ ! -e $ZPLUG_SRC ]]; then
    mkdir -p $ZPLUG_SRC
    git clone https://github.com/zplug/zplug $ZPLUG_SRC
fi

source $ZPLUG_SRC/init.zsh

fpath+=(/etc/profiles/per-user/$USER/share/zsh/site-functions/)
fpath+=(/run/current-system/sw/share/zsh/site-functions/)

zplug "spwhitt/nix-zsh-completions"
zplug "ryutok/rust-zsh-completions"
zplug "marlonrichert/zsh-autocomplete"

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

if ! zplug check; then
    zplug install
fi

zplug load

# conflicts with marlonrichert/zsh-autocomplete
# autoload -U compinit -d $ZSH_DATA/.zcompdump  && compinit -d $ZSH_DATA/.zcompdump

export HISTSIZE="100000"
export SAVEHIST=$HISTSIZE
export HISTFILE=$ZSH_DATA/.zsh_history

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# key bindings
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey '' backward-kill-word

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

# write current location
function update_cwd_file() {
  current_pid=$(echo $$)
  echo $PWD > "/tmp/current-location/zsh-${current_pid}.txt"
}
add-zsh-hook -Uz chpwd update_cwd_file

source $ZDOTDIR/session.sh
