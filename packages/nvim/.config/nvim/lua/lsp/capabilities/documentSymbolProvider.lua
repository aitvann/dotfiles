local telescope = require("telescope.builtin")

return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "gs", telescope.lsp_document_symbols,
        { silent = true, buffer = true, desc = "Go to DOCUMENT Symbols" }
    )
	-- stylua: ignore end
end
