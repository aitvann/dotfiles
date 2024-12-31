local toggling = require("toggling")

return function(_, _, buffer)
    vim.keymap.set("n", "<leader>th", function()
        toggling.toggle("inlay_hints")
        vim.lsp.inlay_hint.enable(toggling.is_enabled("inlay_hints"))
    end, { silent = true, buffer = buffer, desc = "Toggle inlay Hints" })

    vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
end
