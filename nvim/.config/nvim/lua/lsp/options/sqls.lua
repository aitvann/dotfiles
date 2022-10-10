local sqls = require 'sqls'

return {
    on_attach = function(client)
        sqls.on_attach(client)
    end,
}
