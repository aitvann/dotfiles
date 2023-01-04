local telescope = require("telescope.builtin")

return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "gS", telescope.lsp_workspace_symbols,
        { silent = true, buffer = true, desc = "Go to WORKSPACE Symbols" }
    )
	-- stylua: ignore end
end
