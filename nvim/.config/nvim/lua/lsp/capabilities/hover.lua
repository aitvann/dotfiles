return function(_)
    nnoremap('<leader>i', function()
        vim.lsp.buf.hover()
    end, 'silent', 'buffer', 'Inspect node under cursor')
end
