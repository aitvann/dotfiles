local mapx = require 'mapx'
mapx.setup { global = 'force' }

local M = {}

M.get_config_root = function()
    local vimrc = vim.fn.expand '$MYVIMRC'
    local res, _ = vimrc:gsub('/[^/]*$', '')
    return res
end

M.close_buffer_by_name = function(name)
    vim.cmd 'redir => b:cmd_buffers_output'
    vim.cmd 'silent buffers'
    vim.cmd 'redir end'

    local regex = '(%d+)......"' .. name
    local bufnr = vim.b.cmd_buffers_output:match(regex)
    if bufnr then
        vim.cmd('bdelete ' .. bufnr)
    end
end

M.close_current_buffer = function()
    local bufname = vim.api.nvim_exec('echo @%', true)
    local is_term = vim.startswith(bufname, 'term')
    local is_shell = vim.endswith(bufname, 'zsh') or vim.endswith(bufname, 'bash')
    if is_term and is_shell then
        vim.cmd 'Bdelete!'
    else
        vim.cmd 'Bdelete'
    end
end

return M
