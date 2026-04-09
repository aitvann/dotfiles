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

return M
