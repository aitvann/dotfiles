local utils = require("utils")
local whichkey = require("which-key")
local repeat_move = require("repeatable_move")

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

-- Those are not needed with Kitty's cursor trail
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.cursorcolumn = false

-- Tabulation
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Folds
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.fillchars = 'fold: '
vim.cmd("set nofoldenable")

-- Search
vim.o.hlsearch = true
vim.o.incsearch = true
vim.keymap.set("n", "<C-H>", "<cmd>noh<CR>", { silent = true, desc = "no search Highlight" })

vim.filetype.add({
    pattern = {
        [".*/hyprland%.conf"] = "hyprlang",
        [".*/binds%.conf"] = "hyprlang",
    },
})

require('vim._core.ui2').enable({
    enable = true,

    -- TODO: there should be a better way once ui2 is stable
    -- disabling pager so <CR> won't move cursor to it and ruin <localleader> mappings
    msg = {
        targets = {
            ['']         = 'msg',
            empty        = 'cmd',
            bufwrite     = 'msg',
            confirm      = 'cmd',
            emsg         = 'msg',
            echo         = 'msg',
            echomsg      = 'msg',
            echoerr      = 'msg',
            completion   = 'cmd',
            list_cmd     = 'msg',
            lua_error    = 'msg',
            lua_print    = 'msg',
            progress     = 'msg',
            rpc_error    = 'msg',
            quickfix     = 'msg',
            search_cmd   = 'cmd',
            search_count = 'cmd',
            shell_cmd    = 'msg',
            shell_err    = 'msg',
            shell_out    = 'msg',
            shell_ret    = 'msg',
            undo         = 'msg',
            verbose      = 'msg',
            wildlist     = 'cmd',
            wmsg         = 'msg',
        },
    },
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

-- Leader
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Write current buffer" })
vim.keymap.set("n", "<leader>W", ":wa<CR>", { silent = true, desc = "Write ALL buffers" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quite from current editor" })
vim.keymap.set("n", "<leader>Q", ":qa<CR>", { silent = true, desc = "Quite from editor" })
vim.keymap.set("n", "<leader>o", "o<Esc>", { silent = true, desc = "create line ABOVE in normal mode" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { silent = true, desc = "create line BELOW in normal mode" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", "\"+y", { silent = true, desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", "\"+p", { silent = true, desc = "Pate from system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", "\"+d", { silent = true, desc = "Delete and yank to system clipboard" })
vim.keymap.set("n", "<leader>;", function()
    vim.cmd("terminal")
    vim.cmd("startinsert")
    vim.keymap.set("t", "<Esc>", "<C-\\><C-N>",
        { silent = true, buffer = true, desc = "Escape terminal mode with just <Esc>" })
end, { silent = true, desc = "open terminal" })

-- Buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { silent = true, desc = "cycle trought buffers forward" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { silent = true, desc = "cycle trought buffers backward" })
vim.keymap.set("n", "<Backspace>", require("mini.bufremove").delete, { silent = true, desc = "close buffer" })

-- Tabs
vim.keymap.set("n", "gt", ":tabnew %<CR>", { silent = true, desc = "Go to new Tab" })
vim.keymap.set("n", "L", ":tabn<CR>", { silent = true, desc = "cycle tabs to the Left" })
vim.keymap.set("n", "H", ":tabp<CR>", { silent = true, desc = "cycle tabs to the Right" })
vim.keymap.set("n", "<S-Del>", ":tabclose<CR>", { silent = true, desc = "CLOSE tab" })

-- Source: https://youtu.be/7Jtr66Kx0RA?t=4m59s
local win_move = function(key)
    local curwin = vim.api.nvim_win_get_number(0)
    vim.cmd("wincmd " .. key)
    if curwin == vim.api.nvim_win_get_number(0) then
        if key == 'j' or key == 'k' then
            vim.cmd "wincmd s"
        else
            vim.cmd "wincmd v"
        end

        vim.cmd("wincmd " .. key)
    end
end

-- Moving over the windows
whichkey.add({ { "g", group = "Go to" } })
vim.keymap.set("n", "gh", function() win_move("h") end, { silent = true, desc = "Go to the LEFT window" })
vim.keymap.set("n", "gl", function() win_move("l") end, { silent = true, desc = "Go to the RIGHT window" })
vim.keymap.set("n", "gk", function() win_move("k") end, { silent = true, desc = "Go to the ABOVE window" })
vim.keymap.set("n", "gj", function() win_move("j") end, { silent = true, desc = "Go to the BELOW window" })

-- Mirroring current window
whichkey.add({ { "gm", group = "Go Mirror window" } })
vim.keymap.set("n", "gmh", "gh<Del>gh",
    { silent = true, remap = true, desc = "GO to the LEFT window mirroring the current window" })
vim.keymap.set("n", "gml", "gl<Del>gl",
    { silent = true, remap = true, desc = "GO to the RIGHT window mirroring the current window" })
vim.keymap.set("n", "gmk", "gk<Del>gk",
    { silent = true, remap = true, desc = "GO to the ABOVE window mirroring the current window" })
vim.keymap.set("n", "gmj", "gj<Del>gj",
    { silent = true, remap = true, desc = "GO to the BELOW window mirroring the current window" })

-- Moving(pulling) current window
whichkey.add({ { "gp", group = "Go Pull window" } })
vim.keymap.set("n", "gph", "<C-W>h <C-W>x",
    { silent = true, desc = "Go to the LEFT, Pulling the current window with you" })
vim.keymap.set("n", "gpl", "<C-W>l <C-W>x",
    { silent = true, desc = "Go to the RIFHT, Pulling the current window with you" })
vim.keymap.set("n", "gpk", "<C-W>k <C-W>x", { silent = true, desc = "Go UP, Pulling the current window with you" })
vim.keymap.set("n", "gpj", "<C-W>j <C-W>x", { silent = true, desc = "Go DOWN, Pulling the current window with you" })

-- Resizing
vim.keymap.set("n", '<S-Left>', function() vim.fn.ResizeLeft(4) end, { silent = true, desc = 'move window divider LEFT' })
vim.keymap.set("n", '<S-Right>', function() vim.fn.ResizeRight(4) end,
    { silent = true, desc = 'move window divider RIGHT' })
vim.keymap.set("n", '<S-Up>', function() vim.fn.ResizeUp(4) end, { silent = true, desc = 'move window divider UP' })
vim.keymap.set("n", '<S-Down>', function() vim.fn.ResizeDown(4) end, { silent = true, desc = 'move window divider DOWN' })

-- Scrolling
vim.keymap.set("n", "<Left>", "zh", { silent = true, desc = "scroll horizontally to the LEFT" })
vim.keymap.set("n", "<Right>", "zl", { silent = true, desc = "scroll horizontally to the RIGHT" })

-- Navigation
local fzf_lua = require("fzf-lua")
local fzf_lua_frecency = require('fzf-lua-frecency')
vim.keymap.set("n", "gf", function()
    fzf_lua_frecency.frecency({
        cwd_only = true,
        all_files = true,
        display_score = false,
        fzf_opts = { ["--no-sort"] = false }
    })
end, { silent = true, desc = "Go to a File" })
vim.keymap.set("n", "gw", fzf_lua.blines, { silent = true, desc = "Go to Word in the CURRENT buffer" })
-- vim.keymap.set("n", "gW", fzf-lua.grep_project, { silent = true, desc = "Go to Word in the PROJECT" })
vim.keymap.set("n", "gW", function()
        fzf_lua.live_grep({
            -- Enter `blob` mode immediately
            glob_separator = "file:",
            search = "file:*",
            no_esc = true,
            -- Skip filename from search (still displayed)
            fzf_opts = { ['--nth'] = '2..' }
        })
    end,
    { silent = true, desc = "Go to Word in the PROJECT" })
vim.keymap.set("n", "gb", fzf_lua.buffers, { silent = true, desc = "Go to a buffer" })
vim.keymap.set("n", "gJ", fzf_lua.jumps, { silent = true, desc = "Go to Jump point" })

-- repeating paragraph jump
local parag_next = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('}' .. vim.v.count1, true, true, true),
        'n', true)
end
local parag_prev = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('{' .. vim.v.count1, true, true, true),
        'n', true)
end
parag_next, parag_prev = repeat_move.make_repeatable_move_pair(parag_next, parag_prev)
vim.keymap.set({ "n", "x", "o" }, "}", parag_next)
vim.keymap.set({ "n", "x", "o" }, "{", parag_prev)

vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('current_location', { clear = true }),
    desc = "Integration with current-location script: write current location on every location change",
    callback = function(args)
        local filepath = args.file
        -- Writing pids for server and every UI attached to it
        -- Usefull when UI process is not a child of server process (like after :restart)
        if filepath ~= "" and vim.fn.filereadable(filepath) == 1 then
            -- Race condition?
            vim.system(
                vim.iter({ "current-location", "write", "nvim", filepath, utils.get_ui_pids(), vim.uv.os_getpid(),
                    "--nvim-pipe", vim.v.servername }):flatten():totable(),
                { text = true },
                function(result)
                    if result.code ~= 0 then
                        vim.notify("Error writing current location (" .. result.code .. "): " .. result.stderr,
                            vim.log.levels.ERROR)
                    end
                end
            )
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

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("help_buffer_right_split", { clear = true }),
    desc = "Automatically split help buffers to the right",
    pattern = "help",
    command = "wincmd L",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    desc = "Autocreate a dir when saving a file",
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- See https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("correct_terminal_background", { clear = true }),
    desc = "Corrects terminal background color according to colorscheme",
    callback = function()
        if vim.api.nvim_get_hl(0, { name = "Normal" }).bg then
            io.write(string.format("\027]11;#%06x\027\\", vim.api.nvim_get_hl(0, { name = "Normal" }).bg))
        end
        vim.api.nvim_create_autocmd("UILeave", {
            group = vim.api.nvim_create_augroup("correct_terminal_background_leave", { clear = true }),
            callback = function()
                io.write("\027]111\027\\")
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("auto-last-position", { clear = true }),
    desc = "Auto jump to last position",
    callback = function(args)
        local position = vim.api.nvim_buf_get_mark(args.buf, [["]])
        local winid = vim.fn.bufwinid(args.buf)
        pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("auto-equeal-window", { clear = true }),
    desc = "Auto resize window equaly",
    command = "wincmd ="
})
