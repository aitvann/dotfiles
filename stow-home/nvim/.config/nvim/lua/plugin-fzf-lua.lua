local fzf_lua = require("fzf-lua")

-- Saving base configuration in a global variable so it's easy to adjust it per-project
local previewer_prefix = "delta --syntax-theme tokyonight-storm"
FzfLuaConfig = {
    { "ivy", "hide" },
    keymap = {
        fzf = {
            true,
            ["tab"] = "down",
            ["shift-tab"] = "up",
            ["ctrl-space"] = "toggle-down",
            -- send entire search to quickfix list
            ["ctrl-q"] = "select-all+accept",
        }
    },
    actions = {
        files = {
            true,
            -- FIXME: Unable to use mappings below because `<Tab>` is detected as `<C-i>`
            --
            -- Remap to match common mapping for file mangeers
            -- ["alt-h"] = false,
            -- ["ctrl-h"] = FzfLua.actions.toggle_hidden,
            -- Remap to match `ctrl-h` mapping
            -- ["alt-i"] = false,
            -- ["ctrl-i"] = FzfLua.actions.toggle_ignore,
        }
    },
    git = {
        status = { preview_pager = previewer_prefix },
        diff = { preview_pager = previewer_prefix },
        commits = { preview_pager = previewer_prefix },
        bcommits = { preview_pager = previewer_prefix },
        blame = { preview_pager = previewer_prefix },
    },
    lsp = {
        code_actions = {
            -- Enable `delta` preview
            previewer = "codeaction_native",
        },
    },
    previewers = {
        codeaction_native = {
            -- Using recommended config for `delta`
            pager =
                previewer_prefix .. ' --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"',
        },
    }
}

fzf_lua.setup(FzfLuaConfig)

fzf_lua.register_ui_select()

vim.keymap.set("n", "<C-P>", fzf_lua.resume, { silent = true, desc = "show Previous search" })
