local project = require("project_nvim")
local telescope = require("telescope")

project.setup {
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearangne the detection methods.
    detection_methods = { "lsp", "pattern" },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    ignore_lsp = {
        "lua_ls", -- TODO: works as far my only Lua project is my NeoVim config
        "efm"
    },

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {
        vim.fn.expand('$HOME') .. '/dotfiles/hosts/*'
    },

    -- Show hidden files in telescope
    show_hidden = false,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = 'global',

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath("data"),
}

vim.keymap.set("n", "gP", telescope.extensions.projects.projects, { silent = true, desc = "open Projects" })

-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

local hijack_netrw = function()
    local netrw_bufname

    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("telescope-on-enter", { clear = true }),
        pattern = "*",
        callback = function()
            vim.schedule(function()
                if vim.bo[0].filetype == "netrw" then
                    return
                end
                local bufname = vim.api.nvim_buf_get_name(0)
                if vim.fn.isdirectory(bufname) == 0 then
                    _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
                    return
                end

                -- prevents reopening of file-browser if exiting without selecting a file
                if netrw_bufname == bufname then
                    netrw_bufname = nil
                    return
                else
                    netrw_bufname = bufname
                end

                -- ensure no buffers remain with the directory name
                vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

                require("telescope.builtin").find_files({
                    search_dirs = { netrw_bufname }
                })
            end)
        end,
        desc = "telescope replacement for netrw",
    })
end

hijack_netrw()
