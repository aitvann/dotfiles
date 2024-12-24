return function(_, _, buffer)
    local lsp_codelens_refresh = vim.api.nvim_create_augroup('lsp_codelens_refresh', { clear = true })
    vim.lsp.codelens.refresh({ bufnr = buffer })
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        callback = function(_)
            vim.lsp.codelens.refresh({ bufnr = buffer })
        end,
        group = lsp_codelens_refresh,
        buffer = buffer,
    })
    vim.api.nvim_create_autocmd('CursorHold', {
        callback = function(_)
            vim.lsp.codelens.refresh({ bufnr = buffer })
        end,
        group = lsp_codelens_refresh,
        buffer = buffer,
    })
end
