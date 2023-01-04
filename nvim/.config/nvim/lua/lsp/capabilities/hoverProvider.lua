return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover,
        { silent = true, buffer = true, desc = "Inspect node under cursor" }
    )
	-- stylua: ignore end
end
