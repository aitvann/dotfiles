CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export NNN_FIFO=/tmp/nnn.fifo

export NNN_TERMINAL=foot
export NNN_PLUG="p:preview-tui;d:dragdrop;j:fzcd;r:gitroot"

# use trash-cli
export NNN_TRASH=1

export NNN_BMS="\
c:$HOME/.config;\
l:$HOME/.local;\
h:$HOME;\
M:$HOME/mercury;\
m:$HOME/data/knowledge-base/media;\
p:$HOME/playground;\
P:$HOME/.local/share/PrismLauncher/instances"

source $CONFIG_HOME/nnn-quitcd.sh
