local highlight = require 'lualine.highlight'
local utils = require 'lualine.utils.utils'

local M = require('lualine.components.diagnostics'):extend()

local default_options = {
    colored = true,
    symbols = { added = '+', modified = '~', removed = '-' },
    diff_color = {
        added = {
            fg = utils.extract_color_from_hllist(
                'fg',
                { 'GitSignsAdd', 'GitGutterAdd', 'DiffAdded', 'DiffAdd' },
                '#90ee90'
            ),
        },
        modified = {
            fg = utils.extract_color_from_hllist(
                'fg',
                { 'GitSignsChange', 'GitGutterChange', 'DiffChanged', 'DiffChange' },
                '#f0e130'
            ),
        },
        removed = {
            fg = utils.extract_color_from_hllist(
                'fg',
                { 'GitSignsDelete', 'GitGutterDelete', 'DiffRemoved', 'DiffDelete' },
                '#ff0038'
            ),
        },
    },
}

M.init = function(self, options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)

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

    if #vim.lsp.buf_get_clients() == 0 then
        return (colors['error'] or '') .. 'No Lsp'
    end

    local status = M.super.update_status(self)
    if status == '' then
        return (colors['info'] or '') .. 'Ok'
    else
        return status
    end
end

return M
