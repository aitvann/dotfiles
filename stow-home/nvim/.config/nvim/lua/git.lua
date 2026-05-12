local gitsigns = require("gitsigns")

local whichkey = require("which-key")
local repeat_move = require("repeatable_move")

gitsigns.setup({
    signs = {
        add = { text = require('symbols').get("git_add") },
        change = { text = require('symbols').get("git_change") },
        delete = { text = require('symbols').get("git_delete") },
        topdelete = { text = require('symbols').get("git_topdelete") },
        changedelete = { text = require('symbols').get("git_changedelete") },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local next_hunk, prev_hunk = repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

        -- Navigation
        vim.keymap.set({ "n", "x", "o" }, "]h", function()
            if vim.wo.diff then
                return "]h"
            end
            vim.schedule(next_hunk)
            return "<Ignore>"
        end, { expr = true, desc = "GOTO NEXT Hunk" })

        vim.keymap.set({ "n", "x", "o" }, "[h", function()
            if vim.wo.diff then
                return "[h"
            end
            vim.schedule(prev_hunk)
            return "<Ignore>"
        end, { expr = true, desc = "GOTO PREVIOUS Hunk" })

        -- Actions
        whichkey.add({ { "<leader>h", group = "Hunk" } })
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage Hunk" })
        vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Unstage Hunk" })
        vim.keymap.set("n", "<leader>hx", gs.reset_hunk, { buffer = bufnr, desc = "Reset Hunk" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview Hunk" })
        vim.keymap.set("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Stage selected Hunk" })
        vim.keymap.set("v", "<leader>hx", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "Reset selected Hunk" })
        vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Git Stage BUFFER" })
        vim.keymap.set("n", "<leader>gX", gs.reset_buffer, { buffer = bufnr, desc = "Git Reset BUFFER" })
        vim.keymap.set("n", "<leader>gB", function()
            gs.blame_line({ full = true })
        end, { buffer = bufnr, desc = "Git show current line Blame" })
        vim.keymap.set("n", "<leader>tg", gs.toggle_current_line_blame,
            { buffer = bufnr, desc = "Git show current line Blame" })
        vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle Deleted lines" })

        -- Text object
        vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
        vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr }) -- dodiff inner
    end,
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
})

local fzf_lua = require("fzf-lua")
whichkey.add({ { "<leader>g", group = "Git" } })
vim.keymap.set("n", "<leader>gm", fzf_lua.git_commits, { silent = true, desc = "open Git coMMits" })
vim.keymap.set("n", "<leader>gb", fzf_lua.git_branches, { silent = true, desc = "open Git Branches" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGitCurrentFile<CR>", { silent = true, desc = "open Git window" })

local M = {}

M.lazygit_edit_file = function(filename, line)
    local lazygit_win = vim.api.nvim_get_current_win()
    local lazygit_buf = vim.api.nvim_win_get_buf(lazygit_win)
    local lazygit_filetype = vim.bo[lazygit_buf].filetype
    local lazygit_buftype = vim.bo[lazygit_buf].buftype

    if lazygit_buftype == 'terminal' and lazygit_filetype == 'lazygit' then
        -- graceful close, requires `vim.defer_fn`
        -- local channel = vim.bo[lazygit_buf].channel
        -- vim.api.nvim_chan_send(channel, vim.keycode("q"))

        -- force because we are killing lazygit process
        vim.api.nvim_buf_delete(lazygit_buf, { force = true })
    end

    local target_win = vim.api.nvim_get_current_win()
    local target_buf = vim.api.nvim_win_get_buf(target_win)

    local jump_to_line = function()
        if line then
            vim.api.nvim_win_set_cursor(target_win, { line, 1 })
        end
    end

    if vim.api.nvim_buf_get_name(target_buf) == filename then
        jump_to_line()
    else
        local bufnr = vim.fn.bufadd(filename)
        vim.fn.bufload(bufnr)
        vim.api.nvim_win_set_buf(target_win, bufnr)
        jump_to_line()
    end
end

return M
