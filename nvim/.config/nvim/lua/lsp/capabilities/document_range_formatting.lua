return function()
    xnoremap('<leader>f', function()
        vim.lsp.buf.range_formatting()
    end, 'silent', 'buffer', 'Format selected range')
end
