local fzf_lua = require("fzf-lua")

return function(_, _, buffer)
    vim.keymap.set("n", "gs", fzf_lua.lsp_document_symbols,
        { silent = true, buffer = buffer, desc = "Go to DOCUMENT Symbols" }
    )
end
