CONFIG_HOME=$XDG_CONFIG_HOME/zsh

export NNN_FIFO=/tmp/nnn.fifo

# flash firmware to keyboard using only mouse
export NNN_MCLICK='p'

export NNN_TERMINAL=foot
export NNN_PLUG="\
v:preview-tui;\
d:dragdrop;\
j:fzcd;\
r:gitroot;\
w:wallpaper;\
s:xdgdefault;\
o:fzopen;\
y:-!wayland-copy-file \"\$nnn\"*;\
p:!wayland-paste-file*"

# use trash-cli
export NNN_TRASH=1

export NNN_BMS="\
c:$HOME/.config;\
l:$HOME/.local;\
t:$HOME/.local/share/Trash;\
P:$HOME/.local/share/PrismLauncher/instances;\
M:$HOME/mercury;\
p:$HOME/playground;\
m:$HOME/data/knowledge-base/media;\
z:$HOME/data/knowledge-base/media/music;\
i:$HOME/data/knowledge-base/media/images;\
w:$HOME/data/knowledge-base/media/wallpapers;\
e:/run/media/$USER;\
s:/run/current-system/sw;\
u:/etc/profiles/per-user/$USER"

source $CONFIG_HOME/nnn-quitcd.sh
