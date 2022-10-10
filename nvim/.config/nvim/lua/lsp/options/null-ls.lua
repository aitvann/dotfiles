return {
    -- null-ls's `resolved_capabilities` is broken, so disable some features manually
    on_attach = function(client)
        -- FIXME: actually find out if capability is resolved
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/436#issuecomment-993594777
        client.resolved_capabilities = {}
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.document_range_formatting = true
    end,
}
