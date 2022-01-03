local oldreq = require
local require = function(s)
    return oldreq('status-line.components.' .. s)
end

return {
    lsp_status_or_filename = require 'lsp-status-or-filename',
    diagnostics = require 'diagnostics',
}
