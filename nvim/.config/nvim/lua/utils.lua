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

return M
