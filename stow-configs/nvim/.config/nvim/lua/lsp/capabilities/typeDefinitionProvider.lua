local telescope = require("telescope.builtin")

return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "gD", telescope.lsp_type_definitions,
        { silent = true, buffer = true, desc = "Go to type Definitions" }
    )
	-- stylua: ignore end
end
