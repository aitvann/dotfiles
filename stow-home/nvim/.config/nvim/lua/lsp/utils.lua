local M = {}

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

return M
