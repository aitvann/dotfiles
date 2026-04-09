-- must be the first line of config
require("lang-layout")

require("colorscheme")
require("utils")
require("general")
require("lsp")
require("plugin-treesitter")
require("completion")
require("git")
require("commenting")
vim.cmd("source ~/.config/nvim/lua/resize.vim")
require("auto-pairs")
require("align")
require("status-line")
require("plugin-neoscroll")
require("plugin-whichkey")
require("plugin-nvim-colorizer")
require("plugin-project-nvim")
require("plugin-telescope")
require("plugin-conjure")
require("plugin-mini-session")
require("s-expressions")
require("markdown")
-- require("dump-mappings")

-- must be the very last line of config
-- remap Vim keybindings
require('langmapper').automapping({ buffer = false })
