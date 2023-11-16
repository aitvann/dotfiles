showtabline = vim.o.showtabline

-- vim.cmd 'colorscheme kanagawa'
-- require('nightfox').load 'duskfox'
-- vim.cmd 'colorscheme gruvbox'
vim.cmd("colorscheme tokyonight")

-- preserve `showtabline` as setting colorscheme changaes it to `2` for some reason
vim.o.showtabline = showtabline
