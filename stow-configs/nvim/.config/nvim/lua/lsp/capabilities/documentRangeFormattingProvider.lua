return function()
    -- stylua: ignore start
    vim.keymap.set("x", "<leader>f", vim.lsp.buf.format,
        { silent = true, buffer = true, desc = "Format selected range" }
    )
	-- stylua: ignore end
end
