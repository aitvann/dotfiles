local function escape(str)
    -- You need to escape these characters to work correctly
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

-- must be setup before `langmapper.setup` call
vim.g.mapleader = " "
vim.g.maplocalleader = "\r"

require('langmapper').setup({
    -- added Insert mode
    automapping_modes = { 'i', 'n', 'v', 'x', 's' },
})
