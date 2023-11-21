local whichkey = require("which-key")

local M = {}

M.toggles = {}

local default_spec = {
    name = nil, -- no default, required
    initial = false,
    description = "",
    on_enable_hook = function() end,
    on_disable_hook = function() end,
}

M.register = function(spec)
    local spec = {
        name = spec.name,
        initial = spec.initial or default_spec.initial,
        description = spec.description or default_spec.description,
        on_enable_hook = spec.on_enable_hook or default_spec.on_enable_hook,
        on_disable_hook = spec.on_disable_hook or default_spec.on_disable_hook,
    }

    M.toggles[spec.name] = spec
end

M.is_enabled = function(name)
    return vim.b["toggles." .. name]
end

M.enable = function(name)
    M.set_toggle(name, true)
    print(M.toggles[name].description .. " enabled")
end

M.disable = function(name)
    M.set_toggle(name, false)
    print(M.toggles[name].description .. " disabled")
end

M.toggle = function(name)
    if M.is_enabled(name) then
        M.disable(name)
    else
        M.enable(name)
    end
end

M.set_toggle = function(name, value)
    vim.b["toggles." .. name] = value
    local toggle = M.toggles[name]
    if value then
        toggle.on_enable_hook()
    else
        toggle.on_disable_hook()
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("toggling-on-enter", { clear = true }),
    pattern = "*",
    callback = function()
        for name, toggle in pairs(M.toggles) do
            if vim.b["toggles." .. name] == nil then
                M.set_toggle(name, toggle.initial)
            end
        end
    end,
    desc = "telescope replacement for netrw",
})

whichkey.register({ ["t"] = { name = "Toggling" } }, { prefix = "<leader>" })

return M
