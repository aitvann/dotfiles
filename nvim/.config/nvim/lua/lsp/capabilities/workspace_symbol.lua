local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gS', function()
        telescope.lsp_workspace_symbols()
    end, 'silent', 'buffer', 'Go to WORKSPACE Symbols')
end
