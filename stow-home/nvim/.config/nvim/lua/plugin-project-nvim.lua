require('project').setup({
    lsp = {
        enable = false,
    },

    enable_autochdir = false,
})

-- source: https://github.com/nvim-telescope/telescope.nvim/issues/2806#issuecomment-1904877188
local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })
-- clear FileExplorer appropriately to prevent netrw from launching on folders
-- netrw may or may not be loaded before telescope-find-files
-- conceptual credits to nvim-tree and telescope-file-browser
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()
        pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = find_files_hijack_netrw,
    pattern = "*",
    callback = function()
        vim.schedule(function()
            -- Early return if netrw or not a directory
            if vim.bo[0].filetype == "netrw" or vim.fn.isdirectory(vim.fn.expand("%:p")) == 0 then
                return
            end

            vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
            -- Required to trigger 'BufEnter' and other events
            vim.cmd("cd %:p:h")

            require("telescope.builtin").find_files({
                cwd = vim.fn.expand("%:p:h"),
            })
        end)
    end,
})
