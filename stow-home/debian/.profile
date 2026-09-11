# Breaks Gnome for some reason
# if [ -f "$HOME/.local/bin/source-env" ] ; then
#     . "$HOME/.local/bin/source-env"
# fi

# -----------------------------------------------------------------------------
# Copy paste environmet from uwsm/env
# -----------------------------------------------------------------------------

#! /usr/bin/env sh

# Wayland specific (compositor agnostic) settings

export APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'
# Force electron apps to use Wayland
export NIXOS_OZONE_WL=1

# -----------------------------------------------------------------------------
# Copy paste environmet from uwsm/env.d/10-xdg
# -----------------------------------------------------------------------------

#! /usr/bin/env sh

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
# not officially in the specification
export XDG_BIN_HOME="${HOME}/.local/bin"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/password-store"
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/.ripgreprc"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export CARGO_TARGET_DIR="${CARGO_HOME}/shared-target"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
export PSQLRC="${XDG_CONFIG_HOME}/pg/psqlrc"
export PSQL_HISTORY="${XDG_STATE_HOME}/psql_history"
export PGPASSFILE="${XDG_CONFIG_HOME}/pg/pgpass"
export PGSERVICEFILE="${XDG_CONFIG_HOME}/pg/pg_service.conf"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export XCURSOR_PATH="${XDG_DATA_HOME}/icons"
export LEIN_HOME="${XDG_DATA_HOME}/lein"
export SQLITE_HISTORY=${XDG_STATE_HOME}/sqlite_history
export PI_CODING_AGENT_DIR="${XDG_CONFIG_HOME}/pi"

# Might break some systems
# export XCOMPOSEFILE="${XDG_CONFIG_HOME}/X11/xcompose"
# export XCOMPOSECACHE="${XDG_CACHE_HOME}/X11/xcompose"
# export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
# export USERXSESSION="${XDG_CACHE_HOME}/X11/xsession"
# export USERXSESSIONRC="${XDG_CACHE_HOME}/X11/xsessionrc"
# export ALTUSERXSESSION="${XDG_CACHE_HOME}/X11/Xsession"
# export ERRFILE="${XDG_CACHE_HOME}/X11/xsession-errors"

# -----------------------------------------------------------------------------
# Copy paste environmet from uwsm/env.d/11-base-preferences
# -----------------------------------------------------------------------------

#! /usr/bin/env sh

# Only for custom scripts. Install any external software uisng Nix only
export PATH="${XDG_BIN_HOME}:${PATH}"

# -----------------------------------------------------------------------------
# Copy paste environmet from uwsm/env.d/12-debian-preferences
# -----------------------------------------------------------------------------

#! /usr/bin/env sh

export PATH="${CARGO_HOME}/bin:${PATH}"
export PATH="${GOPATH}/bin:${PATH}"

# -----------------------------------------------------------------------------
# Copy paste environmet from uwsm/env.d/20-nnn
# -----------------------------------------------------------------------------

#! /usr/bin/env sh

export NNN_OPTS="aAGr"

export NNN_FIFO=/tmp/nnn.fifo

# flash firmware to keyboard using only mouse
export NNN_MCLICK='p'

export NNN_TERMINAL="${TERMINAL}"

export NNN_PLUG=\
'v:better-preview-tui;'\
'd:dragdrop;'\
'j:fzcd;'\
'r:gitroot;'\
'w:wallpaper;'\
's:xdgdefault;'\
'o:fzopen;'\
'h:!cppath "$nnn"*;'\
'y:-!wayland-copy-file "$nnn"*;'\
'p:!wayland-paste-file*'

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
