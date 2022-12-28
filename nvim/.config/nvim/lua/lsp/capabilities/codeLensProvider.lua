return function(_)
    --[[ local buffer = vim.api.nvim_get_current_buf() ]]
    --[[ local lsp_codelens_refresh = vim.api.nvim_create_augroup('lsp_codelens_refresh', { clear = true }) ]]
    --[[ vim.api.nvim_create_autocmd({'BufEnter', 'InsertLeave', 'BufWritePost'}, { ]]
    --[[     callback = vim.lsp.codelens.refresh, ]]
    --[[     group = lsp_codelens_refresh, ]]
    --[[     buffer = buffer, ]]
    --[[ }) ]]
    --[[ vim.api.nvim_create_autocmd('CursorHold', { ]]
    --[[     callback = vim.lsp.codelens.refresh, ]]
    --[[     group = lsp_codelens_refresh, ]]
    --[[     buffer = buffer, ]]
    --[[ }) ]]
end
