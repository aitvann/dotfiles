local gitsigns = require("gitsigns")

local whichkey = require("which-key")
local builtin = require("telescope.builtin")

local next_integrations = require("nvim-next.integrations")
gitsigns.setup({
    signs = {
        add = { text = "▍" },
        change = { text = "▍" },
        delete = { text = "▸" },
        topdelete = { text = "▾" },
        changedelete = { text = "▍" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local nngs = next_integrations.gitsigns(gs)

        -- Navigation
        vim.keymap.set("n", "]h", function()
            if vim.wo.diff then
                return "]h"
            end
            vim.schedule(nngs.next_hunk)
            return "<Ignore>"
        end, { expr = true, desc = "GOTO NEXT Hunk" })

        vim.keymap.set("n", "[h", function()
            if vim.wo.diff then
                return "[h"
            end
            vim.schedule(nngs.prev_hunk)
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
        vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
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

-- vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitSignsAdd' })
-- vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'GitSignsAddLn' })
-- vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'GitSignsAddNr' })
-- vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitSignsChange' })
-- vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'GitSignsChangeLn' })
-- vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'GitSignsChangeNr' })
-- vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
-- vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { link = 'GitSignsChangeLn' })
-- vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'GitSignsChangeNr' })
-- vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitSignsDelete' })
-- vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'GitSignsDeleteLn' })
-- vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'GitSignsDeleteNr' })
-- vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitSignsDelete' })
-- vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'GitSignsDeleteLn' })
-- vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'GitSignsDeleteNr' })


whichkey.add({ { "<leader>g", group = "Git" } })
vim.keymap.set("n", "<leader>gm", builtin.git_commits, { silent = true, desc = "open Git coMMits" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { silent = true, desc = "open Git Branches" })
