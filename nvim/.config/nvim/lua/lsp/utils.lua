local scandir = require 'plenary.scandir'
local utils = require 'utils'

local M = {}

-- loads options for server
-- module name: the same as langserver name in `lspconfig`
-- module structure:
--     `settings_name` - `string`, name of settings object
--     `settings` - `object`, settings object ot pass to `lspconfig` setup
--     `on_attach` - `fuction(client)`, function to call on `on_attach`
M.load_options_for = function(server)
    local res, module = pcall(require, 'lsp.options.' .. server)
    local server_options = res and module or {}

    local settings = {}
    if server_options.settings_name and server_options.settings then
        settings[module.settings_name] = module.settings
    end

    local on_attach = server_options.on_attach or function() end

    return {
        settings = settings,
        on_attach = on_attach,
    }
end

-- loads options for each langserver from an options directory
M.load_options = function(servers)
    local options = {}
    for _, server in ipairs(servers) do
        options[server] = M.load_options_for(server)
    end
    return options
end

-- calls function for each capability from a capabilities directory if it's resolved
-- module name: the same as appropriate capability
-- module structure:
--     function(capability_value) - function to call if capability were resolved
M.resolve_capabilities = function(resolved_capabilities)
    for capability, value in pairs(resolved_capabilities) do
        local res, module = pcall(require, 'lsp.capabilities.' .. capability)
        if res and value then
            module(value)
        end
    end
end

-- applies each handler from a handlers directory
-- module name: any
-- module structure:
--     handler_name - string, a handler name in `vim.lsp.handlers` object
--     hander - object, a handler object
M.apply_handlers = function()
    local handlers_path = 'lua/lsp/handlers'
    local root = utils.get_config_root()
    local handler_files = scandir.scan_dir(root .. '/' .. handlers_path, { depth = 1 })
    for _, file in ipairs(handler_files) do
        local handler_module = loadfile(file)()
        vim.lsp.handlers[handler_module.handler_name] = handler_module.handler
    end
end

return M
