local components = require("status-line.components")

local lualine = require("lualine")

showtabline = vim.o.showtabline

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },

    -- +-------------------------------------------------+
    -- | A | B | C                             X | Y | Z |
    -- +-------------------------------------------------+
    sections = {
        lualine_a = { "mode" },
        lualine_b = { { "b:gitsigns_head", icon = "" }, "diff" },
        lualine_c = { { components.progress_or_filename, path = 1 } },
        lualine_x = {},
        lualine_y = { { components.diagnostics } },
        lualine_z = { "progress", "location" },
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
        lualine_z = {
            { "tabs", mode = 1 },
            {
                function()
                    vim.o.showtabline = showtabline
                    return ''
                    -- HACK: lualine will set &showtabline to 2 if you have configured
                    -- lualine for displaying tabline. We want to restore the default
                    -- behavior here.
                    -- https://github.com/nvim-lualine/lualine.nvim/pull/1013#issuecomment-1558099544
                end,
            },
        },
    },
    extensions = {},
})
