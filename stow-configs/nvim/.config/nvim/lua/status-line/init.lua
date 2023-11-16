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
		lualine_c = { { components.progress_or_filename, path = 1, file_status = true } },
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
		lualine_z = { "tabs" },
	},
	extensions = {},
})

-- preserve `showtabline` as setting up lualine changaes it to `2` for some reason
vim.o.showtabline = showtabline
