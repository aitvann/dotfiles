local fzf_lua = require("fzf-lua")
fzf_lua.setup({
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
    files = {
        -- TODO: make it a per-project configuration
        hidden = true,
    },
    grep = {
        -- TODO: make it a per-project configuration
        hidden = true,
    },
    lsp = {
        code_actions = {
            -- Enable `delta` preview
            previewer = "codeaction_native",
        },
    },
    previewers = {
        codeaction_native = {
            -- Using recommended config for `delta
            pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
        },
    }
})

fzf_lua.register_ui_select()

vim.keymap.set("n", "<C-P>", FzfLua.resume, { silent = true, desc = "show Previous search" })
