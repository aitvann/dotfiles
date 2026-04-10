return function(_, _, buffer)
    local lsp_document_highlight = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
        group = lsp_document_highlight,
        desc = "Highlight element under the cursor on hold",
        callback = vim.lsp.buf.document_highlight,
        buffer = buffer,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = lsp_document_highlight,
        desc = "Clear highlight of element under the cursor on move",
        callback = vim.lsp.buf.clear_references,
        buffer = buffer,
    })
end
