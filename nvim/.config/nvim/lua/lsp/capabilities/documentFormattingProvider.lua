local toggling = require 'toggling'

return function(_)
    nnoremap('<leader>tf', function()
        toggling.toggle 'fmt_on_save'
    end, 'silent', 'buffer', 'Toggle Formatting on save')

    local buffer = vim.api.nvim_get_current_buf()
    local lsp_document_formatting = vim.api.nvim_create_augroup('lsp_document_formatting', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
            if require 'toggling'.is_enabled 'fmt_on_save' then
                --[[ vim.lsp.buf.formatting_seq_sync() ]]
                vim.lsp.buf.format()
            end
        end,
        group = lsp_document_formatting,
        buffer = buffer,
    })
end
