return function(_)
    nnoremap('<leader>i', function()
        vim.lsp.buf.hover()
    end, 'silent', 'buffer')
end
