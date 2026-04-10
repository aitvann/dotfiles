local utils = require("utils")

local local_session_file = '.session.vim'
require('mini.sessions').setup({
    autoread = false,
    autowrite = true,
    file = local_session_file,
})

-- TODO: ask for session name, use local session if no name provided
vim.keymap.set("n", "<leader>s", function() MiniSessions.write(local_session_file) end,
    { silent = true, desc = "write Session" })
vim.keymap.set("n", "<leader>b", MiniSessions.restart, { silent = true, desc = "reBoot NeoVim" })

local starter = require('mini.starter')
starter.setup({
    evaluate_single = true,
    -- Openning manually when no local session detected
    autoopen = false,
    items = {
        starter.sections.sessions(),
        starter.sections.builtin_actions(),
    },
})

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/" .. local_session_file) == 1 then
            pcall(MiniSessions.read, MiniSessions.config.file)
        elseif not utils.is_something_shown() then
            MiniStarter.open()
        end
    end,
})
