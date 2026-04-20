local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gD", fzf_lua.lsp_typedefs,
        { silent = true, buffer = buffer, desc = "Go to type Definitions" }
    )
end
