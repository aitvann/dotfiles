local which_key = require 'which-key.keys'

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

local function format_mapping(n, map)
    local label = map.label and ' - ' .. map.label or ''
    -- local keys = map.keys.nvim
    -- return get_indent(n) .. '* ' .. keys[#keys] .. label
    return get_indent(n) .. '* `' .. table.concat(map.keys.nvim) .. '`' .. label
end

M.dump_key = function(mod, key, buffer)
    local source = which_key.get_mappings(mod, key, buffer)
    print(format_mapping(#key - 1, source.mapping))
    for _, map in ipairs(source.mappings) do
        if map.id then
            print(format_mapping(#key, map))
        elseif map.group then
            M.dump_key(mod, map.keys.keys, buffer)
        end
    end
end

M.dump = function(mod, buffer)
    return M.dump_key(mod, '', buffer)
end

return M
