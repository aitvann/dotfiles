local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gS", fzf_lua.lsp_workspace_symbols,
        { silent = true, buffer = buffer, desc = "Go to WORKSPACE Symbols" }
    )
end
