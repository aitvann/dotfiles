require("lsp.plugin-renamer")

local lsp_utils = require("lsp.utils")
local toggling = require("toggling")
local diagnostics = require("lsp.diagnostics")

local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local status = require("lsp-status")
local signature = require("lsp_signature")
local null_ls = require("null-ls")
local inlay_hints = require("inlay-hints")

local servers = {
	"rust_analyzer", --rust
	"lua_ls", --lua
	"sqlls", -- sql
	"nil_ls", -- nix
}
local options = lsp_utils.load_options(servers)

-- apply handlers
lsp_utils.apply_handlers()

-- compose `to_attach` functions
local on_attach = function(client, buffer)
	local server_options = options[client.name] or lsp_utils.load_options_for(client.name)
	server_options.on_attach(client)

	signature.on_attach({
		hint_enable = false,
	})
	status.on_attach(client)
	diagnostics.on_attach(client)
	inlay_hints.on_attach(client, buffer)

	lsp_utils.resolve_capabilities(client.server_capabilities)
end

-- construct capabilities object
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend("keep", capabilities, cmp.default_capabilities()) -- update capabilities from 'cmp_nvim_lsp` plugin
capabilities = vim.tbl_extend("keep", capabilities, status.capabilities) -- update capabilities from `lsp-status` plugin

for server_name, server_options in pairs(options) do
	lsp[server_name].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		settings = server_options.settings,
	})
end

-- null-ls
null_ls.setup({
	on_attach = on_attach,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.markdownlint,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml" },
		}),
	},
})

-- inlay_hints
inlay_hints.setup({
	eol = {
		type = {
			format = function(hints)
				return string.format("%s", hints)
			end,
		},
	},
})

-- status
status.register_progress()

-- formatting
toggling.register_initial("fmt_on_save", true)
toggling.register_description("fmt_on_save", "Formatting on save")
