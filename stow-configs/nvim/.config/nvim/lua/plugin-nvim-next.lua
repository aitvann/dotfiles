local nvim_next = require("nvim-next")
local nvim_next_builtins = require("nvim-next.builtins")

nvim_next.setup({
    default_mappings = {
        repeat_style = "original",
    },
    items = {
        nvim_next_builtins.f,
        nvim_next_builtins.t
    }
})
