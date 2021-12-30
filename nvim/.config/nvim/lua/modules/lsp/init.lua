local toggling = require 'toggling'

local lsp = require 'lspconfig'
local cmp = require 'cmp_nvim_lsp'
local status = require 'lsp-status'
local null_ls = require 'null-ls'

local telescope = require 'telescope.builtin'
local telescope_themes = require 'telescope.themes'

local renamer = require 'renamer'
local renamer_utils = require 'renamer.mappings.utils'

local mapx = require 'mapx'
mapx.setup { global = 'force' }

-- compose `to_attach` functions from all pluggins
local on_attach = function(client)
    status.on_attach(client)

    -- mappings
    -- stylua: ignore start
    mapx.group('silent', function()
        nnoremap('gr',          function() telescope.lsp_references() end)
        nnoremap('gd',          function() telescope.lsp_definitions() end)
        nnoremap('gt',          function() telescope.lsp_type_definitions() end)
        nnoremap('gi',          function() telescope.lsp_implementations() end)
        nnoremap('gs',          function() telescope.lsp_document_symbols() end)
        nnoremap('gS',          function() telescope.lsp_workspace_symbols() end)
        nnoremap('<leader>M',   function() telescope.diagnostics() end)
        nnoremap('<leader>m',   function() vim.lsp.diagnostic.show_line_diagnostics({ focusable = false }) end)
        nnoremap('<leader>a',   function() telescope.lsp_code_actions(telescope_themes.get_cursor()) end)
        nnoremap('<leader>i',   function() vim.lsp.buf.hover({ focusable = false }) end)
        nnoremap('<leader>r',   function() renamer.rename() end)
        nnoremap('<leader>R',   function()
            renamer.rename()
            renamer_utils.clear_line()
        end)
    end)
    -- stylua: ignore end

    -- hover highlighting
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end

    -- code_lens
    if client.resolved_capabilities.code_lens then
        vim.cmd [[
            augroup lsp_codelens_refresh
                autocmd! * <buffer>
                autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.lsp.codelens.refresh()
                autocmd CursorHold <buffer> lua vim.lsp.codelens.refresh()
            augroup END
        ]]
    end

    -- inline type hints
    vim.cmd [[
        highlight LspReferenceRead  guibg=#3a405e
        highlight LspReferenceText  guibg=#3a405e
        highlight LspReferenceWrite guibg=#3a405e

        augroup inline_type_hints
            autocmd! * <buffer>
            autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer>
            \ lua require'lsp_extensions'.inlay_hints{ prefix = 'ᐅ ', highlight = "Comment", enabled = {"ChainingHint"} }
        augroup END
    ]]

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

-- construct capabilities object
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities) -- update capabilities from 'cmp_nvim_lsp` plugin
capabilities = vim.tbl_extend('keep', capabilities, status.capabilities) -- update capabilities from `lsp-status` plugin

-- tries to load settings or return empty
local function load_settings(server)
    local res, module = pcall(require, 'modules.lsp.settings.' .. server)
    if res then
        return module
    else
        return {}
    end
end

local servers = {
    'rust_analyzer', --rust
    'sumneko_lua', --lua
}
for _, server in ipairs(servers) do
    lsp[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = load_settings(server),
    }
end

-- enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = false,
    signs = true,
    update_in_insert = true,
})

-- formatting
nnoremap('<leader>tf', '<cmd> lua require"toggling".toggle"fmt_on_save"<CR>', 'silent')
toggling.register_initial('fmt_on_save', true)
toggling.register_description('fmt_on_save', 'Formatting on save')
vim.cmd [[
    augroup fmt
        autocmd!
        autocmd BufWritePre * lua if require'toggling'.is_enabled'fmt_on_save' then vim.lsp.buf.formatting_sync() end
    augroup END
]]

-- null-ls
null_ls.setup {
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.write_good.with {
            filetypes = { 'markdown' },
        },
        null_ls.builtins.formatting.prettier.with {
            filetypes = { 'html', 'json', 'yaml' },
        },
    },
}

-- status
status.register_progress()
status.config {
    current_function = false,

    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'I',
    indicator_hint = '?',
    indicator_ok = 'Ok',
}
