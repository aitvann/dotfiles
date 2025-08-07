local utils = require("utils")

local whichkey = require("which-key")
local builtin = require("telescope.builtin")

vim.o.hidden = true
vim.o.autoread = true
vim.cmd("set nowrap")
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 1000
vim.o.encoding = "utf-8"
vim.cmd("set noshowmode")
vim.o.showtabline = 1
vim.o.termguicolors = true
vim.o.numberwidth = 2
vim.o.timeoutlen = 2000
vim.o.scrolloff = 8
vim.o.laststatus = 3

vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.cmd("highlight CursorLine guibg=#3a405e")

vim.filetype.add({
    pattern = {
        [".*/hyprland%.conf"] = "hyprlang",
        [".*/binds%.conf"] = "hyprlang",
    },
})

-- folds
vim.opt.foldmethod = "expr"
-- WARN: causes significant slowdowns: cmdline cmp, lsp symbols, scrolling
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- deprecated
-- requires NeoVim-nightly
vim.o.foldtext = ''
vim.o.fillchars = 'fold: '

-- HACK:
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    group = vim.api.nvim_create_augroup("unfold-on-enter", { clear = true }),
    pattern = "*",
    callback = function()
        vim.schedule(function()
            vim.cmd [[ normal zR ]]
        end)
    end,
})

vim.keymap.set("i", "jj", "<Esc>", { silent = true })
vim.keymap.set("i", "kk", "<Esc>:w<CR>", { silent = true })
vim.keymap.set("n", "Y", "y$", { silent = true })
vim.keymap.set("n", "U", "<cmd>redo<CR>", { silent = true })
vim.keymap.set("n", "<C-R>", "<C-W>L", { silent = true })
vim.keymap.set("n", "vv", "V", { silent = true })
vim.keymap.set("n", "gi", "gi<Esc>zzi", { silent = true })
vim.keymap.set("x", ">", ">gv", { silent = true })
vim.keymap.set("x", "<", "<gv", { silent = true })
vim.keymap.set("i", "<C-z>", "<Esc>zza", { silent = true })
vim.keymap.set("n", "G", "Gzz", { silent = true })
vim.keymap.set("n", "<Del>", "<cmd>q<CR>", { silent = true, desc = "CLOSE window" })

-- leader
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Write current buffer" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quite from current editor" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { silent = true, desc = "Quite from editor" })
vim.keymap.set("n", "<leader>o", "o<Esc>", { silent = true, desc = "create line ABOVE in normal mode" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { silent = true, desc = "create line BELOW in normal mode" })
vim.keymap.set("n", "<leader>;", function()
    vim.cmd("terminal")
    vim.cmd("startinsert")
    vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { silent = true, buffer = true, desc = "buffer" })
end, { silent = true, desc = "open terminal" })

-- tabulation
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- search
vim.o.hlsearch = true
vim.o.incsearch = true
vim.keymap.set("n", "<C-H>", "<cmd>noh<CR>", { silent = true, desc = "no search Highlight" })

-- buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { silent = true, desc = "cycle trought buffers forward" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { silent = true, desc = "cycle trought buffers backward" })
vim.keymap.set("n", "<Backspace>", utils.close_current_buffer, { silent = true, desc = "close buffer" })

-- tabs
vim.keymap.set("n", "gt", ":tabnew %<CR>", { silent = true, desc = "Go to new Tab" })
vim.keymap.set("n", "L", ":tabn<CR>", { silent = true, desc = "cycle tabs to the Left" })
vim.keymap.set("n", "H", ":tabp<CR>", { silent = true, desc = "cycle tabs to the Right" })
vim.keymap.set("n", "<S-Del>", ":tabclose<CR>", { silent = true, desc = "CLOSE tab" })

-- moving over the windows
whichkey.add({ { "g", group = "Go to" } })
vim.keymap.set("n", "gh", function() vim.fn.WinMove("h") end, { silent = true, desc = "GO to the LEFT window" })
vim.keymap.set("n", "gl", function() vim.fn.WinMove("l") end, { silent = true, desc = "GO to the RIGHT window" })
vim.keymap.set("n", "gk", function() vim.fn.WinMove("k") end, { silent = true, desc = "GO to the ABOVE window" })
vim.keymap.set("n", "gj", function() vim.fn.WinMove("j") end, { silent = true, desc = "GO to the BELOW window" })

-- mirroring current window
whichkey.add({ { "gm", group = "Go Mirror window" } })
vim.keymap.set("n", "gmh", "gh<Del>gh",
    { silent = true, remap = true, desc = "GO to the LEFT window mirroring the current window" })
vim.keymap.set("n", "gml", "gl<Del>gl",
    { silent = true, remap = true, desc = "GO to the RIGHT window mirroring the current window" })
vim.keymap.set("n", "gmk", "gk<Del>gk",
    { silent = true, remap = true, desc = "GO to the ABOVE window mirroring the current window" })
vim.keymap.set("n", "gmj", "gj<Del>gj",
    { silent = true, remap = true, desc = "GO to the BELOW window mirroring the current window" })

-- moving(pulling) current window
whichkey.add({ { "gp", group = "Go Pull window" } })
vim.keymap.set("n", "gph", "<C-W>h <C-W>x",
    { silent = true, desc = "Go to the LEFT, Pulling the current window with you" })
vim.keymap.set("n", "gpl", "<C-W>l <C-W>x",
    { silent = true, desc = "Go to the RIFHT, Pulling the current window with you" })
vim.keymap.set("n", "gpk", "<C-W>k <C-W>x", { silent = true, desc = "Go UP, Pulling the current window with you" })
vim.keymap.set("n", "gpj", "<C-W>j <C-W>x", { silent = true, desc = "Go DOWN, Pulling the current window with you" })

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


vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function(args)
        local filepath = args.file
        if filepath ~= "" then
            local file, err = vim.loop.fs_open("/tmp/current-location/nvim-" .. vim.loop.getpid() .. ".txt", "w", 438) -- 438 is octal for 0666 permissions
            if not file then
                vim.notify("Error opening file: " .. err, vim.log.levels.ERROR)
            else
                local data = vim.fn.json_encode({ location = filepath, nvim_pipe = vim.v.servername })
                vim.loop.fs_write(file, data, -1,
                    function(write_err)
                        if write_err then
                            vim.notify("Error writing file: " .. write_err, vim.log.levels.ERROR)
                        end
                        vim.loop.fs_close(file)
                    end)
            end
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    desc = 'Hightlight selection on yank',
    pattern = '*',
    callback = function()
        vim.hl.on_yank { higroup = 'HighlightedyankRegion', timeout = 300 }
    end,
})

-- resizing
vim.keymap.set("n", '<S-Left>', function() vim.fn.ResizeLeft(4) end, { silent = true, desc = 'move window divider LEFT' })
vim.keymap.set("n", '<S-Right>', function() vim.fn.ResizeRight(4) end,
    { silent = true, desc = 'move window divider RIGHT' })
vim.keymap.set("n", '<S-Up>', function() vim.fn.ResizeUp(4) end, { silent = true, desc = 'move window divider UP' })
vim.keymap.set("n", '<S-Down>', function() vim.fn.ResizeDown(4) end, { silent = true, desc = 'move window divider DOWN' })

-- scrolling
vim.keymap.set("n", "<Left>", "zh", { silent = true, desc = "scroll horizontally to the LEFT" })
vim.keymap.set("n", "<Right>", "zl", { silent = true, desc = "scroll horizontally to the RIGHT" })

-- navigation
vim.keymap.set("n", "gf", function() builtin.find_files({ hidden = true }) end, { silent = true, desc = "Go to a File" })
vim.keymap.set("n", "gw", builtin.current_buffer_fuzzy_find, { silent = true, desc = "Go to Word in the CURRENT buffer" })
vim.keymap.set("n", "gW", builtin.live_grep, { silent = true, desc = "Go to Word in the PROJECT" })
vim.keymap.set("n", "gb", builtin.buffers, { silent = true, desc = "Go to a buffer" })
vim.keymap.set("n", "gJ", builtin.jumplist, { silent = true, desc = "Go to Jump point" })

vim.api.nvim_create_autocmd("FileType", {
    desc = "Automatically Split help Buffers to the right",
    pattern = "help",
    command = "wincmd L",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Autocreate a dir when saving a file",
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- see https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/"
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    desc = "Corrects terminal background color according to colorscheme",
    callback = function()
        if vim.api.nvim_get_hl(0, { name = "Normal" }).bg then
            io.write(string.format("\027]11;#%06x\027\\", vim.api.nvim_get_hl(0, { name = "Normal" }).bg))
        end
        vim.api.nvim_create_autocmd("UILeave", {
            callback = function()
                io.write("\027]111\027\\")
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Remove UI clutter in the terminal",
    callback = function()
        local is_terminal = vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal"
        vim.o.number = not is_terminal
        vim.o.relativenumber = not is_terminal
        vim.o.signcolumn = is_terminal and "no" or "yes"
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Auto jump to last position",
    group = vim.api.nvim_create_augroup("auto-last-position", { clear = true }),
    callback = function(args)
        local position = vim.api.nvim_buf_get_mark(args.buf, [["]])
        local winid = vim.fn.bufwinid(args.buf)
        pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    desc = "Auto resize window equaly",
    group = vim.api.nvim_create_augroup("auto-equeal-window", { clear = true }),
    command = "wincmd ="
})

require('notifications').setup {}
