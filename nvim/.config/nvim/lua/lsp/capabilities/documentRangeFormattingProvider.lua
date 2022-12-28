return function()
    xnoremap('<leader>f', function()
        vim.lsp.buf.format({
            --[[ async = true ]]
        })
    end, 'silent', 'buffer', 'Format selected range')
end
