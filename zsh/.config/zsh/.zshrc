ZSH_DATA=$XDG_DATA_HOME/zsh

export ZPLUG_HOME=$ZSH_DATA/zplug

ZPLUG_SRC=$ZSH_DATA/zplug_src
if [[ ! -e $ZPLUG_SRC ]]; then
    mkdir -p $ZPLUG_SRC
    git clone https://github.com/zplug/zplug $ZPLUG_SRC
fi

source $ZPLUG_SRC/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "marlonrichert/zsh-autocomplete"

if ! zplug check; then
    zplug install
fi

zplug load

# conflicts with marlonrichert/zsh-autocomplete
# autoload -U compinit -d $ZSH_DATA/.zcompdump  && compinit -d $ZSH_DATA/.zcompdump

HISTSIZE="10000"
SAVEHIST=$HISTSIZE
HISTFILE=$ZSH_DATA/.zsh_history

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

autoload -U select-word-style
select-word-style bash

source $ZDOTDIR/session.sh
