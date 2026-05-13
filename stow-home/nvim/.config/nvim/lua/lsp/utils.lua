local M = {}

local utils = require('utils')

-- calls function for each capability from a capabilities directory if it's resolved
-- module name: the same as appropriate capability
-- module structure:
--     function(capability_value) - function to call if capability were resolved
M.resolve_capabilities = function(client, buffer)
    local resolved_capabilities = client.server_capabilities
    for capability, value in pairs(resolved_capabilities) do
        local res, module = pcall(require, "lsp.capabilities." .. capability)
        if res and value then
            module(value, client, buffer)
        end
    end
end

-- applies each handler from a handlers directory
-- module name: any
-- module structure:
--     handler_name - string, a handler name in `vim.lsp.handlers` object
--     hander - object, a handler object
M.apply_handlers = function()
    local handlers_root = utils.get_config_root() .. "/lua/lsp/handlers"
    for filename, _ in vim.fs.dir(handlers_root) do
        local module = 'lsp.handlers.' .. filename:gsub('%.lua$', '')
        local res, handler_module = pcall(require, module)
        if res then
            vim.lsp.handlers[handler_module.handler_name] = handler_module.handler
        end
    end
end

return M
