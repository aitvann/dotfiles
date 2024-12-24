local scandir = require("plenary.scandir")
local utils = require("utils")

local M = {}

-- loads options for each langserver from an options directory
M.load_options = function(servers)
    local options = {}
    for _, server in ipairs(servers) do
        local res, module = pcall(require, "lsp.options." .. server)
        local server_options = res and module or {}
        server_options.on_attach = server_options.on_attach or function(_) end
        options[server] = server_options
    end
    return options
end

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
    local handlers_path = "lua/lsp/handlers"
    local root = utils.get_config_root()
    local handler_files = scandir.scan_dir(root .. "/" .. handlers_path, { depth = 1 })
    for _, file in ipairs(handler_files) do
        local handler_module = loadfile(file)()
        vim.lsp.handlers[handler_module.handler_name] = handler_module.handler
    end
end

return M
