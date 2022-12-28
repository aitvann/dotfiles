local utils = require("utils")

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local mapx = require("mapx")

vim.o.hidden = true
vim.o.autoread = true
vim.cmd("set nowrap")
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 1000
vim.o.encoding = "utf-8"
vim.cmd("set noshowmode")
vim.o.showtabline = 2
vim.o.termguicolors = true
vim.o.numberwidth = 2
vim.o.timeoutlen = 2000

vim.o.cursorline = true
vim.cmd("highlight CursorLine guibg=#3a405e")

mapx.group("silent", function()
	inoremap("jj", "<Esc>")
	nnoremap("Y", "y$")
	nnoremap("U", "<cmd>redo<CR>")
	nnoremap("<Del>", "<cmd>q<CR>")
	nnoremap("<C-R>", "<C-W>L")
	nnoremap("vv", "V")
	nnoremap("gi", "gi<Esc>zzi")
	xnoremap(">", ">gv")
	xnoremap("J", "<cmd>m '>+1<CR>gv=gv")
	xnoremap("K", "<cmd>m '<-2<CR>gv=gv")
end)

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
mapx.group("silent", function()
	nnoremap("<leader>o", "o<Esc>", "create line ABOVE in normal mode")
	nnoremap("<leader>O", "O<Esc>", "create line BELOW in normal mode")
	nnoremap("<leader>;", function()
		vim.cmd("terminal")
		vim.cmd("startinsert")
		tnoremap("<Esc>", "<C-\\><C-N>", "buffer")
	end, "open terminal")
end)

-- tabulation
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- search
vim.o.hlsearch = true
vim.o.incsearch = true
nnoremap("<C-H>", "<cmd>noh<CR>", "silent", "no search Highlight")

-- buffers
mapx.group("silent", function()
	nnoremap("<Tab>", "<cmd>bnext<CR>", "cycle trought buffers forward")
	nnoremap("<S-Tab>", "<cmd>bprevious<CR>", "cycle trought buffers backward")
	nnoremap("<Backspace>", utils.close_current_buffer, "close buffer")
end)

-- tabs
mapx.group("silent", function()
	nnoremap("gt", ":tabnew %<CR>", "Go to new Tab")
	nnoremap("L", ":tabn<CR>", "cycle tabs to the Left")
	nnoremap("H", ":tabp<CR>", "cycle tabs to the Right")
	nnoremap("<S-Del>", ":tabclose<CR>", "CLOSE tab")
end)

-- moving over the windows
-- stylua: ignore start
mapx.nname('g', 'Go to')
mapx.group('silent', function()
    nnoremap('gh', function() vim.fn.WinMove('h') end, 'GO to the LEFT window')
    nnoremap('gl', function() vim.fn.WinMove('l') end, 'GO to the RIGHT window')
    nnoremap('gk', function() vim.fn.WinMove('k') end, 'GO to the ABOVE window')
    nnoremap('gj', function() vim.fn.WinMove('j') end, 'GO to the BELOW window')
end)
-- stylua: ignore end

-- mirroring current window
mapx.nname("gm", "Go Mirror window")
mapx.group("silent", function()
	nmap("gmh", "gh<Del>gh", "GO to the LEFT window mirroring the current window")
	nmap("gml", "gl<Del>gl", "GO to the RIGHT window mirroring the current window")
	nmap("gmk", "gk<Del>gk", "GO to the ABOVE window mirroring the current window")
	nmap("gmj", "gj<Del>gj", "GO to the BELOW window mirroring the current window")
end)

-- moving(pulling) current window
mapx.nname("gp", "Go Pull window")
mapx.group("silent", function()
	nnoremap("gph", "<C-W>h <C-W>x", "Go to the LEFT, Pulling the current window with you")
	nnoremap("gpl", "<C-W>l <C-W>x", "Go to the RIFHT, Pulling the current window with you")
	nnoremap("gpk", "<C-W>k <C-W>x", "Go UP, Pulling the current window with you")
	nnoremap("gpj", "<C-W>j <C-W>x", "Go DOWN, Pulling the current window with you")
end)

vim.cmd([[
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
]])

-- resizing
-- stylua: ignore start
mapx.group('silent', function()
    nnoremap('<S-Left>', function() vim.fn.ResizeLeft(4) end, 'move window divider LEFT')
    nnoremap('<S-Right>', function() vim.fn.ResizeRight(4) end, 'move window divider RIGHT')
    nnoremap('<S-Up>', function() vim.fn.ResizeUp(4) end, 'move window divider UP')
    nnoremap('<S-Down>', function() vim.fn.ResizeDown(4) end, 'move window divider DOWN')
end)
-- stylua: ignore end

-- scrolling
mapx.group("silent", function()
	noremap("<Left>", "zh", "scroll horizontally to the LEFT")
	noremap("<Right>", "zl", "scroll horizontally to the RIGHT")
end)

-- navigation
-- stylua: ignore start
mapx.group('silent', function()
    nnoremap('gf', function() builtin.find_files { hidden = true } end, 'Go to a File')
    nnoremap('gw', function() builtin.current_buffer_fuzzy_find() end, 'Go to Word in the CURRENT buffer')
    nnoremap('gW', function() builtin.live_grep() end, 'Go to Word in the PROJECT')
    nnoremap('gb', function() builtin.buffers() end, 'Go to a buffer')
    nnoremap('gJ', function() builtin.jumplist() end, 'Go to Jump point')
    inoremap('<C-j>', function() telescope.extensions.emoji.search() end, 'insert emoJi')
end)
-- stylua: ignore end
