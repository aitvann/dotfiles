local highlight = require 'lualine.highlight'

local M = require('lualine.components.diagnostics'):extend()

M.init = function(self, options)
    M.super.init(self, options)

    if self.options.colored then
        self.highlights = {
            error = highlight.create_component_highlight_group(
                self.options.diagnostics_color.error,
                'diagnostics_error',
                self.options
            ),
            warn = highlight.create_component_highlight_group(
                self.options.diagnostics_color.warn,
                'diagnostics_warn',
                self.options
            ),
            info = highlight.create_component_highlight_group(
                self.options.diagnostics_color.info,
                'diagnostics_info',
                self.options
            ),
            hint = highlight.create_component_highlight_group(
                self.options.diagnostics_color.hint,
                'diagnostics_hint',
                self.options
            ),
        }
    end
end

M.update_status = function(self)
    local colors = {}
    if self.options.colored then
        -- load the highlights and store them in colors table
        for name, highlight_name in pairs(self.highlights) do
            colors[name] = highlight.component_format_highlight(highlight_name)
        end
    end

    if #vim.lsp.get_clients() == 0 then
        return (colors['error'] or '') .. 'No Lsp'
    end

    local status = M.super.update_status(self)
    if status == '' then
        return (colors['hint'] or '') .. 'Ok'
    else
        return status
    end
end

return M
