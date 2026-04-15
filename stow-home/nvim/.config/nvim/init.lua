vim.g.has_ui = #vim.api.nvim_list_uis() > 0
vim.g.has_gui = vim.g.has_ui and (vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil)

-- must be the first line of config
require("lang-layout")

require("colorscheme")
require("utils")
require("general")
require("lsp")
require("plugin-treesitter")
require("completion")
require("git")
require("image")
require("commenting")
vim.cmd("source ~/.config/nvim/lua/resize.vim")
require("auto-pairs")
require("align")
require("status-line")
require("session")
require("plugin-neoscroll")
require("plugin-whichkey")
require("plugin-nvim-colorizer")
require("plugin-project-nvim")
require("plugin-telescope")
require("plugin-tiny-cmdline-nvim")
require("plugin-conjure")
require("plugin-kitty-scrollback-nvim")
require("s-expressions")
require("markdown")
require("notifications")
-- require("dump-mappings")

-- must be the very last line of config
-- remap Vim keybindings
require('langmapper').automapping({ buffer = false })
