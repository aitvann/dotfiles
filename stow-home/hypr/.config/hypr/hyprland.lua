local function endswith(haystack, needle)
    local suffix = string.sub(haystack, -(#needle))
    return suffix == needle
end

local function hl_source_glob(pattern)
    local p = io.popen("ls " .. pattern .. " 2>/dev/null")
    if not p then return end
    for f in p:lines() do
        if endswith(f, '.lua') then
            local chunk, err = loadfile(f)
            if chunk then
                chunk()
            else
                io.stderr:write("hl_source_glob: " .. tostring(err) .. "\n")
            end
        end
    end
    p:close()
end

-- only one color pallet import at a time
require("color-pallets.tokyonight-storm")
-- require("color-pallets.catppuccin-macchiato")

-- only one style import at a time
require("styles.tokyonight-storm-magenta2")
-- require("styles.catpuccin-macchiato-teal")

require("hardware")
require("binds")
hl_source_glob("~/.config/hypr/modules/*")

hl.on("hyprland.start", function()
    hl.exec_cmd("app2unit -s s -- ~/.config/eww/init.sh")
    hl.exec_cmd("app2unit -s s -- pypr")
    hl.exec_cmd("current-location clear")
    hl.exec_cmd("apply-gtk-settings")
end)

hl.curve("easeInOutSin", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2,
    bezier = "easeInOutSin",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "easeInOutSin",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 1,
    bezier = "easeInOutSin",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 4,
    bezier = "easeInOutSin",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2,
    bezier = "easeInOutSin",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2,
    bezier = "easeInOutSin",
})

hl.plugin.load(os.getenv("XDG_DATA_HOME") .. "/hypr/plugins/libhypr-dynamic-cursors.so")
if hl.plugin.dynamic_cursors then
    hl.config { plugin = { dynamic_cursors = {
        enabled = true,

        -- sets the cursor behaviour, supports these values:
        -- tilt    - tilt the cursor based on x-velocity
        -- rotate  - rotate the cursor based on movement direction
        -- stretch - stretch the cursor shape based on direction and velocity
        -- none    - do not change the cursors behaviour
        mode = "tilt",
        threshold = 2,

        tilt = {
            limit = 5000,
            activation = "negative_quadratic",
            window = 100,
        },

        shake = {
            enabled = false,
        },

        hyprcursor = {
            enabled = true,
            nearest = true,
            resolution = -1,
            fallback = "clientside",
        }
    } } }
end


hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = primaryContainer,
            inactive_border = surfaceContainer,
        },
        -- cursor_inactive_timeout = 10
        layout = "master",
        no_focus_fallback = true,
        snap = {
            enabled = true,
        },
    },
    master = {
        orientation = "right",
        new_on_top = true,
        mfact = 0.60,
    },
    input = {
        kb_layout = "us,ru",
        -- kb_options = grp:caps_toggle
        -- kb_options = caps:none
        scroll_factor = 0.8,
        float_switch_override_focus = 1,
        follow_mouse = 1,
        special_fallthrough = true,
        -- not available option: move focus to previously focused window
        focus_on_close = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = false,
        },
    },
    decoration = {
        rounding = 5,
        dim_inactive = true,
        dim_strength = 0.2,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
        shadow = {
            enabled = true,
            range = 12,
            color = shadow,
            -- only active windows with shadow
            color_inactive = "rgba(00000000)",
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        disable_splash_rendering = true,
        -- disabled because triggers window focus even on notifications
        -- does not work perfectrly with pypr sckratch pads
        focus_on_activate = false,
        -- not available option: current worckspace tracking
        initial_workspace_tracking = 1,
        -- disabling because it didn't help once but is annoing
        enable_anr_dialog = false,
    },
    binds = {
        scroll_event_delay = 50,
        allow_workspace_cycles = false,
    },
    cursor = {
        persistent_warps = true,
        warp_on_change_workspace = 1,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
        -- remembering is not persistant among reboots
        enforce_permissions = false,
    },
})

hl.window_rule({
    match = { title = "^(.*)MetaMask(.*)$", },
    float = true,
})

hl.window_rule({
    match = { class = "^(Rofi)$", },
    float = true,
})

hl.window_rule({
    match = { class = "^(eww)$" },
    float = true,
})

hl.window_rule({
    match = { class = "^(ags)$" },
    float = true,
})

hl.window_rule({
    match = { class = "^(xdg-desktop-portal)$" },
    float = true,
})

hl.window_rule({
    match = { class = "^(kitty)$", },
    min_size = "(monitor_w*0.5) (monitor_h*0.6)",
})

hl.window_rule({
    match = {
        class = "^(org.telegram.desktop)$",
        title = "^(Media viewer)$",
    },
    maximize = true,
})

hl.window_rule({
    match = { class = "Minecraft", },
    idle_inhibit = "focus",
})

hl.window_rule({
    match = { class = "^(org.telegram.desktop)$", },
    float = true,
})

hl.window_rule({
    match = { title = "^(terminal-popup)$", },
    float = true,
})

hl.window_rule({
    match = { title = "^(music-player)$", },
    float = true,
})

hl.window_rule({
    match = { title = "^(Picture-in-Picture)$", },
    no_dim = true,
    float = true,
    pin = true,
    move = "12 43",
})
