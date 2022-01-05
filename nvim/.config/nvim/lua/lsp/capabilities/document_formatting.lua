local toggling = require 'toggling'

return function(_)
    nnoremap('<leader>tf', function()
        toggling.toggle 'fmt_on_save'
    end, 'silent', 'buffer', 'Toggle Formatting on save')

    vim.cmd [[
        augroup fmt
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua if require'toggling'.is_enabled'fmt_on_save' then vim.lsp.buf.formatting_seq_sync() end
        augroup END
    ]]
end
