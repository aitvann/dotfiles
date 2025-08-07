return {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
            inlayHints = {
                enable = true,
                chainingHint = true,
                typeHints = true,
                parameterHints = true,
            },
            semanticHighlighting = {
                strings = {
                    -- disable because it overrides TreeSitter injections
                    enable = false,
                }
            }
        },
    },
    on_attach = function(_client, _buffer)
        -- language server specific `on_attach` function example here
    end,
}
