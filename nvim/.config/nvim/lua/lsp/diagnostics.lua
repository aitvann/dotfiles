-- diagnostics does not depend on any capability

local telescope = require 'telescope.builtin'
local mapx = require 'mapx'

local M = {}

M.on_attach = function(_)
    -- mappings
    -- stylua: ignore start
    mapx.group('silent', 'buffer', function()
        nnoremap('<leader>M',   function() telescope.diagnostics() end, 'show PROJECT diagnostics (Messages)')
        nnoremap('<leader>m',   function() vim.lsp.diagnostic.show_line_diagnostics() end, 'show CURRENT LINE diagnostics (Messages)')
        nnoremap('[d',          function() vim.diagnostic.goto_prev() end, 'GOTO NEXT diagnostics')
        nnoremap(']d',          function() vim.diagnostic.goto_next() end, 'GOTO PREVIOUS diagnostics')
    end)
    -- stylua: ignore end

    -- diagnostics in line number
    vim.cmd [[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticError
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticWarn
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticInfo
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticHint
    ]]
end

return M
