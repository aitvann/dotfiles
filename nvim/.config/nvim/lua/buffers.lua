local utils = require 'utils'
local mapx = require 'mapx'

mapx.group('silent', function()
    nnoremap('<Tab>', '<cmd>bnext<CR>')
    nnoremap('<S-Tab>', '<cmd>bprevious<CR>')
    nnoremap('<Backspace>', function()
        utils.close_current_buffer()
    end)
    nnoremap('<leader>;', function()
        vim.cmd 'terminal'
        vim.cmd 'startinsert'
        tnoremap('<Esc>', '<C-\\><C-N>')
    end)
end)
