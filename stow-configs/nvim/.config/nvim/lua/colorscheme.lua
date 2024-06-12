-- vim.cmd 'colorscheme kanagawa'
-- require('nightfox').load 'duskfox'
-- vim.cmd 'colorscheme gruvbox'
-- vim.cmd("colorscheme catppuccin-macchiato")

vim.cmd("colorscheme tokyonight")
vim.api.nvim_set_hl(0, "ColorColumn", { link = "CursorColumn" })
vim.api.nvim_set_hl(0, "Folded", { link = "CursorColumn" })
-- vim.api.nvim_set_hl(0, "Folded", { link = "AerialLine" }) -- only works in Markdown
