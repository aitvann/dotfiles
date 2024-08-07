local toggling = require("toggling")

return function(_)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format()
        vim.api.nvim_command 'wa'
    end, { silent = true, buffer = true, desc = "Format current buffer" })

    vim.keymap.set("n", "<leader>tf", function()
        toggling.toggle("fmt_on_save")
    end, { silent = true, buffer = true, desc = "Toggle Formatting on save" })

    local buffer = vim.api.nvim_get_current_buf()
    local lsp_document_formatting = vim.api.nvim_create_augroup("lsp_document_formatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if toggling.is_enabled("fmt_on_save") then
                --[[ vim.lsp.buf.formatting_seq_sync() ]]
                vim.lsp.buf.format()
            end
        end,
        group = lsp_document_formatting,
        buffer = buffer,
    })
end
