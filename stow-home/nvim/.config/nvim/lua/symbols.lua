local M = {}

local symbols_table = {
    ["foldopen"] = { glyph = '󰅀', ascii = 'v' },
    ["foldclose"] = { glyph = '󰅂', ascii = '>' },
    ["foldinner"] = { glyph = '│', ascii = '|' },

    ["indent"] = { glyph = '▏', ascii = ' ' },

    ["statusline_component_sep_left"] = { glyph = '│', },
    ["statusline_component_sep_right"] = { glyph = '│', },
    ["statusline_section_sep_left"] = { glyph = '', },
    ["statusline_section_sep_right"] = { glyph = '', },

    ["git_branch"] = { glyph = '', },

    ["git_add"] = { glyph = '▍', ascii = '|' },
    ["git_change"] = { glyph = '▍', ascii = '|' },
    ["git_delete"] = { glyph = '▸', ascii = '-' },
    ["git_topdelete"] = { glyph = '▾', ascii = 'v' },
    ["git_changedelete"] = { glyph = '▍', ascii = '|' },

    ["spinner_1"] = { glyph = '⠋', ascii = '.' },
    ["spinner_2"] = { glyph = '⠙', ascii = '..' },
    ["spinner_3"] = { glyph = '⠹', ascii = '...' },
    ["spinner_4"] = { glyph = '⠸', ascii = '.' },
    ["spinner_5"] = { glyph = '⠼', ascii = '..' },
    ["spinner_6"] = { glyph = '⠴', ascii = '...' },
    ["spinner_7"] = { glyph = '⠦', ascii = '.' },
    ["spinner_8"] = { glyph = '⠧', ascii = '..' },
    ["spinner_9"] = { glyph = '⠇', ascii = '...' },
    ["spinner_10"] = { glyph = '⠏', ascii = '.' },
}

M.get = function(name)
    local symbol = symbols_table[name]
    if type(symbol) == 'table' then
        return vim.g.has_gui and symbol.glyph or symbol.ascii
    end

    return symbol
end

return M
