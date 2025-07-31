local autopairs = require("nvim-autopairs")

autopairs.setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    enable_check_bracket_line = false,
})
