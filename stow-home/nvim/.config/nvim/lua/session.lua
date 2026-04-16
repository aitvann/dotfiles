local utils = require("utils")

-- Ideal launch behaviour:
-- - [x] With a file specified -> open the file
-- - [x] With a directory specified -> open file picker
-- - [x] Nothing specified but from a directory with local session -> open the local session
-- - [ ] Nothing specified buf from a directory that corresponds to a global session (which one?) -> open the global session
-- - [x] Nothing specified and no session could be found -> open startup page

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
    group = vim.api.nvim_create_augroup('open_startup_page', { clear = true }),
    desc = "Open startup page when there is nothing else to show and there is no local session (ignore global sessions)",
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
