local toggling = require("toggling")
local conform = require("conform")

return function(_, _, buffer)
    vim.keymap.set({ "n" }, "<leader>f", function()
        conform.format({ lsp_format = "prefer", async = true, bufnr = buffer }, function(err, _)
            if err then
                vim.notify("Failed to format: " .. vim.inspect(err))
            end
        end)
    end, { silent = true, buffer = buffer, desc = "Format current buffer" })

    vim.keymap.set("n", "<leader>tf", function()
        toggling.toggle("fmt_on_save")
    end, { silent = true, buffer = buffer, desc = "Toggle Formatting on save" })
end
