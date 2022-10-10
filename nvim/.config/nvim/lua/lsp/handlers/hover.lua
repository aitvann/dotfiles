return {
    handler_name = 'textDocument/hover',
    handler = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
        focusable = false,
    }),
}
