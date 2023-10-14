local lsp_status = require 'lsp-status'

local M = require('lualine.components.filename'):extend()

local function is_not_nill(obj)
    return obj ~= nil
end

M.init = function(self, options)
    M.super.init(self, options)
end

local spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local function format_lsp_message(message)
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local spinner = spinners[frame + 1]
    local percentage = message.percentage and message.percentage .. '%%' or ''
    local msg = { message.title, message.message }
    vim.tbl_filter(is_not_nill, msg)
    return string.format('%s %s %s', spinner, percentage, table.concat(msg, ': '))
end

M.update_status = function(self)
    local messages = lsp_status.messages()
    if #messages > 0 then
        return format_lsp_message(messages[1])
    else
        return M.super.update_status(self)
    end
end

return M
