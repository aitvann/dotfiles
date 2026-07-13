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
require("icons")
require("image")
require("commenting")
require("auto-pairs")
require("align")
require("status-line")
require("session")
require("plugin-modificator-nvim")
require("plugin-neoscroll")
require("plugin-whichkey")
require("plugin-nvim-colorizer")
require("plugin-tiny-cmdline-nvim")
require("plugin-conjure")
require("plugin-fzf-lua")
require("plugin-kitty-scrollback-nvim")
require("plugin-live-rename-nvim")
require("quickfix")
require("s-expressions")
require("symbols")
require("textobjects")
require("markdown")
require("notifications")
-- require("dump-mappings")

local modules_dir = require('utils').get_config_root() .. '/lua/modules'
if vim.uv.fs_stat(modules_dir) then
    for name, _ in vim.fs.dir(modules_dir) do
        if name:match('%.lua$') then
            local module = 'modules.' .. name:gsub('%.lua$', '')
            local ok, err = pcall(require, module)
            if not ok then
                vim.notify('Failed to load ' .. module .. ': ' .. err, vim.log.levels.WARN)
            end
        end
    end
end

-- must be the very last line of config
-- remap Vim keybindings
require('langmapper').automapping({ buffer = false })
