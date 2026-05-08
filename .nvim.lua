require('fzf-lua').setup(vim.tbl_extend('force', FzfLuaConfig or {}, {
    files = { hidden = true },
    grep = { hidden = true }
}))
