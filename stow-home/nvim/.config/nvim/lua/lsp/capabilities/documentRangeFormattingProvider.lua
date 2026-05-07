local conform = require("conform")

return function(_, _, buffer)
    vim.keymap.set({ "x" }, "<leader>f", function()
        conform.format({ lsp_format = "prefer", async = true, bufnr = buffer }, function(err, _)
            if err then
                vim.notify("Failed to format: " .. vim.inspect(err))
            end

            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end)
    end, { silent = true, buffer = buffer, desc = "Format selected range" })
end
