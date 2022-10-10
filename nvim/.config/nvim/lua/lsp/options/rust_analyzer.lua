return {
    settings_name = 'rust-analyzer',
    settings = {
        checkOnSave = {
            command = 'check',
        },
    },
    on_attach = function()
        -- inlay type hints
        vim.cmd [[
            highlight LspReferenceRead  guibg=#3a405e
            highlight LspReferenceText  guibg=#3a405e
            highlight LspReferenceWrite guibg=#3a405e

            augroup inline_type_hints
                autocmd! * <buffer>
                autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer>
                \ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }
            augroup END
        ]]
    end,
}
