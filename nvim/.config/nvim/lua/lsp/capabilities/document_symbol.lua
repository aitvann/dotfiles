local telescope = require 'telescope.builtin'

return function(_)
    nnoremap('gs', function()
        telescope.lsp_document_symbols()
    end, 'silent', 'buffer', 'Go to DOCUMENT Symbols')
end
