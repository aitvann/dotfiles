-- showmethekey
hl.window_rule({
    match = { initial_title = "^(Floating Window - Show Me The Key)$", },
    float = true,
    pin = true,
    no_dim = true,
    border_size = 0,
    no_shadow = true,
    no_focus = true,
    no_blur = true,
    size = "(monitor_w*0.2) (monitor_h*0.06)",
    move = "((monitor_w*0.5)-(monitor_w*0.2)*0.5) (monitor_h*0.9)",
})
