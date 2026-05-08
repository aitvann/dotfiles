local components = require("status-line.components")

local lualine = require("lualine")

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = {
            left = require('symbols').get('statusline_component_sep_left'),
            right = require('symbols').get('statusline_component_sep_right')
        },
        section_separators = {
            left = require('symbols').get('statusline_section_sep_left'),
            right = require('symbols').get('statusline_section_sep_right')
        },
        disabled_filetypes = {},
        always_divide_middle = true,
        always_show_tabline = false,
    },

    -- +-------------------------------------------------+
    -- | A | B | C                             X | Y | Z |
    -- +-------------------------------------------------+
    sections = {
        lualine_a = { "mode" },
        lualine_b = { { "b:gitsigns_head", icon = require('symbols').get('git_branch') }, "diff", components.macro },
        lualine_c = { {
            components.progress_or_filename,
            path = 1,
            icon = '',
            symbols = {
                spinner = {
                    require('symbols').get('spinner_1'),
                    require('symbols').get('spinner_2'),
                    require('symbols').get('spinner_3'),
                    require('symbols').get('spinner_4'),
                    require('symbols').get('spinner_5'),
                    require('symbols').get('spinner_6'),
                    require('symbols').get('spinner_7'),
                    require('symbols').get('spinner_8'),
                    require('symbols').get('spinner_9'),
                    require('symbols').get('spinner_10'),
                },
            },
        } },
        lualine_x = {},
        lualine_y = { { components.diagnostics } },
        lualine_z = { "searchcount", "selectioncount", "progress", "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { "tabs", mode = 1 } },
    },
    extensions = {},
})
