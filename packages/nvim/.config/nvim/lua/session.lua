vim.cmd([[
    let g:startify_session_before_save = [ 'call CloseGit()' ]

    function! CloseGit()
        exec 'DiffviewClose'
        call luaeval('require"utils".close_buffer_by_name"NeogitStatus"')
    endfunction
]])

-- <leader>s = Session
vim.keymap.set("n", "<leader>sl", "<cmd>SLoad<CR>", { silent = true, desc = "Session Load" })
vim.keymap.set("n", "<leader>ss", "<cmd>SSave<CR>", { silent = true, desc = "Session Save" })
vim.keymap.set("n", "<leader>sd", "<cmd>SDelete<CR>", { silent = true, desc = "Session Delete" })
vim.keymap.set("n", "<leader>sc", "<cmd>SClose<CR>", { silent = true, desc = "Session Close" })
