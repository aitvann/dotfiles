local toggling = require("toggling")

return function(_, _, buffer)
    vim.keymap.set("n", "<leader>f", function()
        -- sync by default
        -- specifying client breaks formatting
        vim.lsp.buf.format({ bufnr = buffer, timeout_ms = 10000 })
        -- not needed when using sync format
        -- vim.api.nvim_command 'w'
    end, { silent = true, buffer = buffer, desc = "Format current buffer" })

    vim.keymap.set("n", "<leader>tf", function()
        toggling.toggle("fmt_on_save")
    end, { silent = true, buffer = buffer, desc = "Toggle Formatting on save" })

    local lsp_document_formatting = vim.api.nvim_create_augroup("lsp_document_formatting", { clear = false })
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if toggling.is_enabled("fmt_on_save") then
                -- sync by default
                -- specifying client breaks formatting
                vim.lsp.buf.format({ bufnr = buffer })
            end
        end,
        group = lsp_document_formatting,
        buffer = buffer,
    })
end
