local icons = require('mini.icons')

icons.setup({
    style = vim.g.has_gui and "glyph" or "ascii",
})

icons.mock_nvim_web_devicons()
icons.tweak_lsp_kind()
