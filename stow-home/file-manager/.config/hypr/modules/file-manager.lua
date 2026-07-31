hl.window_rule({
    match = { title = "^(nnn-file-manager)$", },
    float = true,
})

-- hl.window_rule({
--     match = { title = "^(nnn-file-manager-preview)$", },
--     dim_around = true,
-- })
hl.window_rule({
    match = { title = "^(nnn-file-manager-preview)$", },
    float = true,
})

-- hl.window_rule({
--     match = { title = "^(nnn-file-manager)$", },
--     size = "(monitor_w*0.3) (monitor_h*0.6)",
--     move = "(monitor_w*0.08) (monitor_h*0.2)",
-- })
-- hl.window_rule({
--     match = { title = "^(nnn-file-manager-preview)$", },
--     size = "(monitor_w*0.5) (monitor_h*0.8)",
--     move = "(monitor_w*0.4) (monitor_h*0.1)",
-- })

-- HACK: until I figure out Kitty min window size
hl.window_rule({
    match = { title = "^(nnn-file-manager)$", },
    size = "(monitor_w*0.3) (monitor_h*0.6)",
    move = "(monitor_w*0.1) (monitor_h*0.2)",
})
hl.window_rule({
    match = { title = "^(nnn-file-manager-preview)$", },
    size = "(monitor_w*0.5) (monitor_h*0.8)",
    move = "(monitor_w*0.5) (monitor_h*0.1)",
})

hl.window_rule({
    match = { title = "^(nnn-file-manager)$", },
    no_dim = true,
})

hl.window_rule({
    match = { title = "^(nnn-file-manager-preview)$", },
    no_dim = true,
})

hl.window_rule({
    match = { title = "^(nnn-file-manager-preview)$", },
    no_initial_focus = true,
    no_anim = true,
})

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("app2unit -- bb ~/.local/bin/file-manager"),
    { description = "launch file Explorer" })
