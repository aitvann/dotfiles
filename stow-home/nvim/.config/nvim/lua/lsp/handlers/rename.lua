local plenary_path = require('plenary.path')

-- make path relative to CWD
local get_relative_path = function(file_path)
    local parsed_path = vim.uri_to_fname(file_path)
    local path = plenary_path:new(parsed_path)
    local relative_path = path:make_relative(vim.fn.getcwd())
    return './' .. relative_path
end

-- source: https://github.com/chrisgrieser/.config/blob/b700e4fbca81c6bd9600d1120dd5419d6ff50551/nvim/lua/config/autocmds.lua#L459
local notify_changes_summary = function(result)
    if not result then return end

    local new_name = {}
    local msg = {}
    if result.changes then
        msg = vim.iter(pairs(result.changes))
            :map(function(f, c)
                local first_change = c and c[1]
                if first_change and first_change.newText then
                    new_name = first_change.newText
                end

                return ('%d changes: %s'):format(#c, get_relative_path(f))
            end)
            :totable()
    elseif result.documentChanges then
        msg = vim.iter(result.documentChanges)
            :map(function(c)
                local first_edit = c and c.edits and c.edits[1]
                if first_edit and first_edit.newText then
                    new_name = first_edit.newText
                end

                local uri = c.textDocument and c.textDocument.uri or c.newUri
                local count = c and c.edits and #c.edits or 0
                return ('%d changes: %s'):format(count, get_relative_path(uri))
            end)
            :totable()
    end

    -- Does not work as intended with live-rename.nvim: returns new word
    local curr_name = vim.fn.expand('<cword>')
    local title = ('Rename: %s -> %s'):format(curr_name, new_name)
    vim.notify(title .. '\n' .. table.concat(msg, '\n'))
end

-- source: https://github.com/serhez/nvim-config/blob/d8283825dd688179e3f6d764fbc773c40a4e4e9e/lua/lsp.lua#L119
local write_changed_files = function(result)
    if not result then return end

    local write_buf = function(buf)
        if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_call(buf, function() vim.cmd("w") end)
        end
    end

    if result.changes then
        for uri in vim.iter(result.changes) do
            write_buf(vim.uri_to_bufnr(uri))
        end
    elseif result.documentChanges then
        for c in vim.iter(result.documentChanges) do
            write_buf(vim.uri_to_bufnr(c.textDocument.uri))
        end
    end
end

local handler_name = "textDocument/rename"
local orig_handler = vim.lsp.handlers[handler_name]
return {
    handler_name = handler_name,
    handler = function(err, result, ctx, config)
        notify_changes_summary(result)
        orig_handler(err, result, ctx, config)
        write_changed_files(result)
    end,
}
