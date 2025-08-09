return {
    settings = {
        -- NeoVim-specific settings should be in `.luarc.json` file
        Lua = {
            workspace = {
                -- TODO: figure out how to put it it `.luarc.json` file
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
