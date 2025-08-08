local utils = require("utils")

local M = require('lualine.components.lsp_status'):extend()

M.filename_component = require('lualine.components.filename'):extend()
function M.filename_component:init(options)
    return M.filename_component.super.init(self, options)
end

function M:init(options)
    self.filename_component.super.init(self.filename_component, options)
    return M.super.init(self, options)
end

function M:update_status()
    local data = M.super.update_status(self)
    local filename_data = M.filename_component.super.update_status(self.filename_component)

    -- spinning character is 3 bytes long
    if utils.contains(self.options.symbols.spinner, data:sub(-3)) then
        return data
    else
        return filename_data
    end
end

return M
