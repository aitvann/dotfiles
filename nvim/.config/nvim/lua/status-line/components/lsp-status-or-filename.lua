local lsp_status = require 'lsp-status'

local M = require('lualine.components.filename'):extend()

M.init = function(self, options)
    M.super.init(self, options)
end

local spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local function format_lsp_message(message)
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local spinner = spinners[frame + 1]
    local title = message.title or 'No title'
    local msg = message.message or 'no message'
    return spinner .. ' ' .. title .. ': ' .. msg
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
