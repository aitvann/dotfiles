-- diagnostics does not depend on any capability

local telescope = require 'telescope.builtin'
local mapx = require 'mapx'

local M = {}

M.on_attach = function(_)
    -- mappings
    -- stylua: ignore start
    mapx.group('silent', 'buffer', function()
        nnoremap('<leader>M', function() telescope.diagnostics() end)
        nnoremap('<leader>m', function() vim.lsp.diagnostic.show_line_diagnostics() end)
    end)
    -- stylua: ignore end

    -- diagnostics in line number
    vim.cmd [[
        highlight DiagnosticLineNrError   guifg=#FF0000 gui=bold
        highlight DiagnosticLineNrWarn    guifg=#FFA500 gui=bold
        highlight DiagnosticLineNrInfo    guifg=#00AA00 gui=bold
        highlight DiagnosticLineNrHint    guifg=#CCCCCC gui=bold

        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
    ]]
end

return M
