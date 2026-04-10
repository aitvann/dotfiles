local bufdelete = require 'bufdelete'

local M = {}

M.get_config_root = function()
    local vimrc = vim.fn.expand("$MYVIMRC")
    local res, _ = vimrc:gsub("/[^/]*$", "")
    return res
end

M.close_buffer_by_name = function(name)
    vim.cmd("redir => b:cmd_buffers_output")
    vim.cmd("silent buffers")
    vim.cmd("redir end")

    local regex = '(%d+)......"' .. name
    local bufnr = vim.b.cmd_buffers_output:match(regex)
    if bufnr then
        bufdelete.bufdelete(bufnr, true)
    end
end

M.close_current_buffer = function()
    local bufname = vim.api.nvim_exec("echo @%", true)
    local is_term = vim.startswith(bufname, "term")
    local is_shell = vim.endswith(bufname, "zsh") or vim.endswith(bufname, "bash")
    if is_term and is_shell then
        bufdelete.bufdelete(0, true)
    else
        bufdelete.bufdelete(0, false)
    end
end

M.contains = function(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

--- Returns a list (Lua table) of all attached UI process PIDs.
--- Works with the built-in TUI and external UIs (Neovide, etc.).
--- PIDs that are not reported by the UI are simply skipped.
---
--- @return integer[] List of UI PIDs (empty table if none)
M.get_ui_pids = function()
    local pids = {}

    -- nvim_list_uis() returns all currently attached UIs
    for _, ui in ipairs(vim.api.nvim_list_uis()) do
        -- Get full channel info for this UI
        local chan_info = vim.api.nvim_get_chan_info(ui.chan)

        -- The UI PID is stored here (set by the client via nvim_set_client_info)
        local pid = chan_info
            and chan_info.client
            and chan_info.client.attributes
            and chan_info.client.attributes.pid

        if pid then
            table.insert(pids, pid)
        end
    end

    return pids
end

-- Returns true if NeoVim was started with an intent to show something
-- Copied from `mini.starter`, I wish this functions was exported
M.is_something_shown = function()
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

return M
