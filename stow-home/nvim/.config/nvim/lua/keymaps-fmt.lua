local M = {}

M.template = function(str, vars)
    return (str:gsub("{{(%w+)}}", vars))
end

M.format_keymaps_mode = function(mode, maybe_full)
    local full = maybe_full or false

    local keymaps_dump = vim.api.nvim_get_keymap(mode)
    local keymaps_dump_with_descfmt = vim.iter(keymaps_dump)
        :map(function(keymap)
            keymap["descfmt"] = keymap.desc or keymap.rhs
            return keymap
        end)
        :totable()

    table.sort(keymaps_dump_with_descfmt, function(a, b)
        if a.lhs ~= b.lhs then
            return a.lhs < b.lhs
        end

        if not a.descfmt or not b.descfmt then return false end

        return a.descfmt < b.descfmt
    end)

    local keymaps = vim.iter(keymaps_dump_with_descfmt)
        :filter(function(keymap) return full or keymap.descfmt end)
        :map(function(keymap)
            -- Escape code block character so it renders nicely in markdown
            -- local key = vim.fn.keytrans(keymap.lhs):gsub('`', '\\`')
            local key = vim.fn.keytrans(keymap.lhs)
            return '- `' .. key .. '`: ' .. (keymap.descfmt or '')
        end)
        :totable()

    return table.concat(keymaps, '\n')
end

M.format_keymaps = function()
    local template = [[
# Keymap

This is a list of configured keymaps.

## Normal

Normal mode mappings.

{{normal}}

## Insert

Insert mode mappings.

{{insert}}

## Visual Or Select

Visual or select (`x`) mode mappings.

{{visual}}

## Operator

Text objects mappings.

{{operator}}
]]

    local res = M.template(template, {
        normal = M.format_keymaps_mode('normal'),
        insert = M.format_keymaps_mode('insert'),
        visual = M.format_keymaps_mode('x'),
        operator = M.format_keymaps_mode('o'),
    })

    return res
end

return M
