local sessions = require("mini.sessions")
local starter = require("mini.starter")

-- Ideal launch behaviour:
-- - [x] With a file specified -> open the file
-- - [x] With a directory specified -> open file picker
-- - [x] Nothing specified but from a directory with local session -> open the local session
-- - [ ] Nothing specified buf from a directory that corresponds to a global session (which one?) -> open the global session
-- - [x] Nothing specified and no session could be found -> open startup page

local local_session_file = '.session.vim'
sessions.setup({
    autoread = false,
    autowrite = true,
    file = local_session_file,
})

-- TODO: ask for session name, use local session if no name provided
vim.keymap.set("n", "<leader>s", function() sessions().write(local_session_file) end,
    { silent = true, desc = "write Session" })
vim.keymap.set("n", "<leader>b", sessions.restart, { silent = true, desc = "reBoot NeoVim" })

starter.setup({
    evaluate_single = true,
    -- Openning manually when no local session detected
    autoopen = false,
    items = {
        starter.sections.sessions(),
        starter.sections.builtin_actions(),
    },
})

-- Returns true if NeoVim was started with an intent to show something
-- Copied from `mini.starter`, I wish this functions was exported
local is_something_shown = function()
    -- That is when at least one of the following is true:
    -- - There are files in arguments (like `nvim foo.txt` with new file).
    if vim.fn.argc() > 0 then return true end

    -- - Several buffers are listed (like session with placeholder buffers). That
    --   means unlisted buffers (like from `nvim-tree`) don't affect decision.
    local listed_buffers = vim.tbl_filter(
        function(buf_id) return vim.fn.buflisted(buf_id) == 1 end,
        vim.api.nvim_list_bufs()
    )
    if #listed_buffers > 1 then return true end

    -- - Current buffer is meant to show something else
    if vim.bo.filetype ~= '' then return true end

    -- - Current buffer has any lines (something opened explicitly).
    -- NOTE: Usage of `line2byte(line('$') + 1) < 0` seemed to be fine, but it
    -- doesn't work if some automated changed was made to buffer while leaving it
    -- empty (returns 2 instead of -1). This was also the reason of not being
    -- able to test with child Neovim process from 'tests/helpers'.
    local n_lines = vim.api.nvim_buf_line_count(0)
    if n_lines > 1 then return true end
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
    if string.len(first_line) > 0 then return true end

    return false
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup('open_startup_page', { clear = true }),
    desc = "Open startup page when there is nothing else to show and there is no local session (ignore global sessions)",
    nested = true,
    callback = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/" .. local_session_file) == 1 then
            pcall(sessions.read, sessions.config.file)
        elseif not is_something_shown() then
            starter.open()
        end
    end,
})
