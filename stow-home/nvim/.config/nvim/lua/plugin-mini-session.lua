local session_file = '.session.vim'
require('mini.sessions').setup({
    autoread = true,
    autowrite = true,
    -- disable global session
    directory = '',
    file = session_file,
})

vim.keymap.set("n", "<leader>s", function() MiniSessions.write(session_file) end,
    { silent = true, desc = "write Session" })
vim.keymap.set("n", "<leader>b", function()
    MiniSessions.write(session_file)
    vim.cmd "restart"
end, { silent = true, desc = "reBoot NeoVim" })
