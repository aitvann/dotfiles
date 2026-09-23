if vim.g.has_gui and vim.fn.executable('notify-send') == 1 then
    require('desktop-notifications').setup {}
elseif vim.g.has_ui then
    -- TODO: figure out no-gui fallback keymap for closing notifications
    require('mini.notify').setup({
        lsp_progress = { enable = false },

        window = {
            config = {
                border = "rounded"
            },
        },
    })
end
