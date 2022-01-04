return function(_)
    vim.cmd [[
        augroup lsp_codelens_refresh
            autocmd! * <buffer>
            autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.lsp.codelens.refresh()
            autocmd CursorHold <buffer> lua vim.lsp.codelens.refresh()
        augroup END
    ]]
end
