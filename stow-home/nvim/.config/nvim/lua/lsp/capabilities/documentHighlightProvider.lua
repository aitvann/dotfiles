return function(_, _, buffer)
    local lsp_document_highlight = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
        callback = vim.lsp.buf.document_highlight,
        group = lsp_document_highlight,
        buffer = buffer,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
        callback = vim.lsp.buf.clear_references,
        group = lsp_document_highlight,
        buffer = buffer,
    })
end
