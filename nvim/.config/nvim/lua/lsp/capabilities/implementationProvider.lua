local telescope = require("telescope.builtin")

return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "gi", telescope.lsp_implementations,
        { silent = true, buffer = true, desc = "Go to Implementations" }
    )
	-- stylua: ignore end
end
