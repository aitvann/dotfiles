mainMod = "SUPER"

hl.bind(mainMod .. " + + + SHIFT + Q", hl.dsp.window.close(), { description = "Quite from active window" })
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "TOGGLE floating" })
hl.bind(mainMod .. " + I", hl.dsp.layout("swapwithmaster"), { description = "make master (Inspect) active window" })
hl.bind(mainMod .. " + tab", hl.dsp.window.cycle_next({ next = true }), { description = "CYCLE next window" })
hl.bind(mainMod .. " + tab", hl.dsp.window.bring_to_top(), { description = "CYCLE next window" })
hl.bind(mainMod .. " + + + SHIFT + tab", hl.dsp.window.cycle_next({ prev = true }), { description = "CYCLE prev window" })
hl.bind(mainMod .. " + + + SHIFT + tab", hl.dsp.window.bring_to_top(), { description = "CYCLE prev" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "go to fake Fullscreen" })
hl.bind(mainMod .. " + + + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "go to Fullscreen" })
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/keyboard.clj switch"),
    { description = "SWITCH keyboard layout" })

-- motifications
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("dunstctl close"), { repeating = true })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("dunstctl context"))

hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("app2unit -- bb ~/.local/bin/git-ui"), { description = "launch Git" })
hl.bind(mainMod .. " + + + SHIFT + SemiColon", hl.dsp.exec_cmd("app2unit -- bb ~/.local/bin/terminal"),
    { description = "launch TERMINAL" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("bb ~/.local/bin/create-hidden-snapshot"),
    { description = "create hidden snapshot (View)" })

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("rofi -show drun -theme launcher -run-command \"app2unit -- {cmd}\""),
    { description = "LAUNCH program" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("rofi-pass --last-used"), { description = "select Password" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("rofi -show calc -theme calculator"),
    { description = "openup calculator (Arithmetic) popup" })
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("rofimoji"), { description = "openup EMOJI popup" })

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy -t image/png"),
    { description = "make Screenshot" })
hl.bind(mainMod .. " + + + SHIFT + S", hl.dsp.exec_cmd("grim - | wl-copy -t image/png"),
    { description = "make FULLSCREEN Schreenshot" })
hl.bind(mainMod .. " + W",
    hl.dsp.exec_cmd("wl-paste -t image/png | satty --filename - --early-exit --init-tool brush --copy-command wl-copy"),
    { description = "edit (Write) data from clipboard" })
hl.bind(mainMod .. " + + + SHIFT + W",
    hl.dsp.exec_cmd(
        "wl-paste -t image/png | satty --filename - --fullscreen --early-exit --init-tool brush --copy-command wl-copy"),
    { description = "edit (Write) data from clipboard in FULLSCREEN" })

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pypr toggle messenger"), { description = "toggle MUSIC window" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("pypr toggle telegram"), { description = "toggle Telegram window" })
hl.bind(mainMod .. " + SemiColon", hl.dsp.exec_cmd("pypr toggle terminal"), { description = "toggle TERMINAL window" })
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr toggle music-player"), { description = "toggle MUSIC window" })

-- Media
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/audio.clj mute sink"),
    { description = "toggle output mute" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/audio.clj up sink"),
    { repeating = true, description = "rise output volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/audio.clj down sink"),
    { repeating = true, description = "lower output volumen" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/brightness.clj up"),
    { repeating = true, description = "rise brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/eww/components/bar/system/brightness.clj down"),
    { repeating = true, description = "lower brightness" })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "move window focus to the LEFT" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "move window focus to the RIGHT" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "move window focus to the UP" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "move window focus to the DOWN" })

-- Move windows
hl.bind(mainMod .. " + + + SHIFT + H", hl.dsp.layout("removemaster"), { description = "DRAG active window to the LEFT" })
hl.bind(mainMod .. " + + + SHIFT + L", hl.dsp.layout("addmaster"), { description = "DRAG active window to the RIGHT" })
hl.bind(mainMod .. " + + + SHIFT + K", hl.dsp.window.move({ direction = "u" }),
    { description = "DRAG active window to the UP" })
hl.bind(mainMod .. " + + + SHIFT + J", hl.dsp.window.move({ direction = "d" }),
    { description = "DRAG active window to the DOWN" })

-- Resize windows
hl.bind(mainMod .. " + Left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }),
    { repeating = true, description = "Resize active window to the LEFT" })
hl.bind(mainMod .. " + Right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }),
    { repeating = true, description = "Resize active window to the RIGhT" })
hl.bind(mainMod .. " + Up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }),
    { repeating = true, description = "Resize active window to the UP" })
hl.bind(mainMod .. " + Down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }),
    { repeating = true, description = "Resize active window to the DOWN" })

-- Switch workspaces
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }), { description = "got to workspace 1" })
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }), { description = "got to workspace 2" })
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }), { description = "got to workspace 3" })
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }), { description = "got to workspace 4" })
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }), { description = "got to workspace 5" })
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }), { description = "got to workspace 6" })
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }), { description = "got to workspace 7" })
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }), { description = "got to workspace 8" })
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }), { description = "got to workspace 9" })
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }), { description = "got to workspace 10" })

-- Move active window to a workspace
hl.bind(mainMod .. " + + + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }),
    { description = "MOVE active window to workspace 1" })
hl.bind(mainMod .. " + + + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }),
    { description = "MOVE active window to workspace 2" })
hl.bind(mainMod .. " + + + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }),
    { description = "MOVE active window to workspace 3" })
hl.bind(mainMod .. " + + + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }),
    { description = "MOVE active window to workspace 4" })
hl.bind(mainMod .. " + + + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }),
    { description = "MOVE active window to workspace 5" })
hl.bind(mainMod .. " + + + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }),
    { description = "MOVE active window to workspace 6" })
hl.bind(mainMod .. " + + + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }),
    { description = "MOVE active window to workspace 7" })
hl.bind(mainMod .. " + + + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }),
    { description = "MOVE active window to workspace 8" })
hl.bind(mainMod .. " + + + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }),
    { description = "MOVE active window to workspace 9" })
hl.bind(mainMod .. " + + + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }),
    { description = "MOVE active window to workspace 10" })

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "scroll to next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "scroll to previous workspace" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { description = "move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "resice window" })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.close(), { description = "kill window" })
hl.bind(mainMod .. " + + + SHIFT + mouse:273", hl.dsp.window.float({ action = "toggle" }),
    { description = "toggle floating" })
