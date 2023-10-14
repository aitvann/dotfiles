local oldreq = require
local require = function(s)
    return oldreq('status-line.components.' .. s)
end

return {
    progress_or_filename = require 'progress-or-filename',
    diagnostics = require 'diagnostics',
}
