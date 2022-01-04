local utils = require 'utils'
local builtin = require 'telescope.builtin'
local mapx = require 'mapx'

vim.o.hidden = true
vim.o.autoread = true
vim.cmd 'set nowrap'
vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 1000
vim.o.encoding = 'utf-8'
vim.cmd 'set noshowmode'
vim.o.showtabline = 2
vim.o.termguicolors = true
vim.o.numberwidth = 2

mapx.group('silent', function()
    inoremap('jj', '<Esc>')
    nnoremap('Y', 'y$')
    nnoremap('U', '<cmd>redo<CR>')
    nnoremap('<Del>', '<cmd>q<CR>')
    nnoremap('<C-R>', '<C-W>L')
    nnoremap('vv', 'V')
    xnoremap('>', '>gv')
    xnoremap('J', '<cmd>m \'>+1<CR>gv=gv')
    xnoremap('K', '<cmd>m \'<-2<CR>gv=gv')
end)

-- leader
vim.g.mapleader = '\''
vim.g.maplocalleader = '\''
mapx.group('silent', function()
    nnoremap('<leader>o', 'o<Esc>')
    nnoremap('<leader>O', 'O<Esc>')
end)

-- tab
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- search
vim.o.hlsearch = true
vim.o.incsearch = true
nnoremap('<C-H>', '<cmd>noh<CR>', 'silent')

-- buffers
mapx.group('silent', function()
    nnoremap('<Tab>', '<cmd>bnext<CR>')
    nnoremap('<S-Tab>', '<cmd>bprevious<CR>')
    nnoremap('<Backspace>', utils.close_current_buffer)
    nnoremap('<leader>;', function()
        vim.cmd 'terminal'
        vim.cmd 'startinsert'
        tnoremap('<Esc>', '<C-\\><C-N>')
    end)
end)

-- tabs
mapx.group('silent', function()
    nnoremap('gt', ':tabnew %<CR>')
    nnoremap('H', ':tabn<CR>')
    nnoremap('L', ':tabp<CR>')
    nnoremap('<S-Del>', ':tabclose<CR>')
end)

-- moving over the windows
-- stylua: ignore start
mapx.group('silent', function ()
    nnoremap('gh', function() vim.fn.WinMove('h') end)
    nnoremap('gl', function() vim.fn.WinMove('l') end)
    nnoremap('gk', function() vim.fn.WinMove('k') end)
    nnoremap('gj', function() vim.fn.WinMove('j') end)
end)
-- stylua: ignore end

-- moving(swapping) current window
mapx.group('silent', function()
    nnoremap('gsh', '<C-W>h <C-W>x')
    nnoremap('gsj', '<C-W>j <C-W>x')
    nnoremap('gsk', '<C-W>k <C-W>x')
    nnoremap('gsl', '<C-W>l <C-W>x')
end)

vim.cmd [[
    function! WinMove(key)
        let t:curwin = winnr()
        exec "wincmd ".a:key
        if (t:curwin == winnr())
            if (match(a:key, '[jk]'))
                wincmd v
            else
                wincmd s
            endif
            exec "wincmd ".a:key
        endif
    endfunction
]]

-- resizing
-- stylua: ignore start
mapx.group('silent', function ()
    nnoremap('<S-Left>',    function() vim.fn.ResizeLeft(4) end)
    nnoremap('<S-Right>',   function() vim.fn.ResizeRight(4) end)
    nnoremap('<S-Up>',      function() vim.fn.ResizeUp(4) end)
    nnoremap('<S-Down>',    function() vim.fn.ResizeDown(4) end)
end)
-- stylua: ignore end

-- scrolling
mapx.group('silent', function()
    noremap('<Left>', 'zh')
    noremap('<Right>', 'zl')
end)

-- navigation
-- stylua: ignore start
mapx.group('silent', function()
    nnoremap('gf', function() builtin.find_files { hidden = true } end)
    nnoremap('gw', function() builtin.current_buffer_fuzzy_find() end)
    nnoremap('gW', function() builtin.live_grep() end)
    nnoremap('gb', function() builtin.buffers() end)
    nnoremap('gJ', function() builtin.jumplist() end)
    inoremap('<C-j>', function() telescope.extensions.emoji.search() end)
end)
-- stylua: ignore end
