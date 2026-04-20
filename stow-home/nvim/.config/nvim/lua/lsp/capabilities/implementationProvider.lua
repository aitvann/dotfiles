local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gi", fzf_lua.lsp_implementations,
        { silent = true, buffer = buffer, desc = "Go to Implementations" }
    )
end
