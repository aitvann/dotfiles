return function(_)
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action,
        { silent = true, buffer = true, desc = "show code Actions" }
    )
	-- stylua: ignore end
end
