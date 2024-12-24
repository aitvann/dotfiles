return function(_, _client, buffer)
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action,
        { silent = true, buffer = buffer, desc = "show code Actions" }
    )
	-- stylua: ignore end
end
