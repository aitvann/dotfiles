local toggling = require("toggling")
local conform = require("conform")

conform.setup({
    format_after_save = function(_)
        if toggling.is_enabled("fmt_on_save") then
            return { lsp_format = "prefer" }
        end
    end,
})

return function(_, _, buffer)
    vim.keymap.set({ "n", "x" }, "<leader>f", function()
        conform.format({ lsp_format = "prefer", async = true, bufnr = buffer }, function(err, _)
            if err then
                vim.notify("Failed to format: " .. vim.inspect(err))
            end

            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end)
    end, { silent = true, buffer = buffer, desc = "Run formaters" })

    vim.keymap.set("n", "<leader>tf", function()
        toggling.toggle("fmt_on_save")
    end, { silent = true, buffer = buffer, desc = "Toggle Formatting on save" })
end
