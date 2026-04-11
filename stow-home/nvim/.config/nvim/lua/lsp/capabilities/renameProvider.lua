local live_rename = require("live-rename")

-- NOTE: could also be implemented with overriden `vim.ui.input` element, like
-- [floating-input.nvim](https://github.com/liangxianzhe/floating-input.nvim)
return function(_, _, buffer)
    vim.keymap.set("n", "<leader>r", live_rename.rename,
        { silent = true, buffer = buffer, desc = "PARTIALLY Rename object under cursor" })
    vim.keymap.set("n", "<leader>R", function()
        live_rename.rename({ text = "", insert = true })
    end, { silent = true, buffer = buffer, desc = "COPLETELY Rename object under cursor" })
end
