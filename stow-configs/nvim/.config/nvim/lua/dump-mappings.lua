local whichkey = require 'which-key.keys'

local M = {}

local tab_size = 2

local function repeat_char(ch, n)
    local res = ''
    for _ = 1, n, 1 do
        res = res .. ch
    end
    return res
end

local function get_indent(n)
    return repeat_char(repeat_char(' ', tab_size), n)
end

-- determines if the mapping is user defined or not
local function user_defined(map)
    local desc = map.desc or ''
    local label = map.label or ''

    local no_preset = not map.preset
    local no_nvim_desc = not string.find(desc, "nvim") and not string.find(desc, "Nvim")
    local no_nvim_label = not string.find(label, "nvim") and not string.find(label, "Nvim")
    return no_preset and no_nvim_desc and no_nvim_label
end

local function format_mapping(n, map)
    local msg = map.desc or map.label
    local desc = msg and ' - ' .. msg or ''
    -- local keys = map.keys.nvim
    -- return get_indent(n) .. '* ' .. keys[#keys] .. label
    return get_indent(n) .. '- `' .. table.concat(map.keys.notation) .. '`' .. desc
end

-- @param mod char: mapping mode (n, v, i, ..)
-- @param key string: first keys of mapping
-- @param buffer num: buffer id
-- @param result string: result
M.dump_key = function(mod, key, buffer, result)
    local res = result or ''
    local source = whichkey.get_mappings(mod, key, buffer)
    res = res .. format_mapping(#key - 1, source.mapping) .. '\n'
    for _, map in ipairs(source.mappings) do
        if map.group then
            res = res .. M.dump_key(mod, map.keys.keys, buffer)
        elseif user_defined(map) then
            res = res .. format_mapping(#key, map) .. '\n'
        end
    end
    return res
end

-- @param mod char: mapping mode (n, v, i, ..)
-- @param buffer num: buffer id
-- usage:
-- ```vim
-- :lua require("dump-mappings").dump("n", 0)
-- ````
M.dump = function(mod, buffer)
    vim.fn.setreg('"', M.dump_key(mod, '', buffer))
end

return M
