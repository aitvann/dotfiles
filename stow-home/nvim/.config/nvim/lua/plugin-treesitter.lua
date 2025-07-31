local configs = require("nvim-treesitter.configs")
local context_commentstring = require('ts_context_commentstring')
local next_integrations = require("nvim-next.integrations")

next_integrations.treesitter_textobjects()

configs.setup({
    sync_install = false,
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true,    -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "yaml" } },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "select OUTER part of a Function region" },
                ["if"] = { query = "@function.inner", desc = "select INNER part of a Function region" },
                ["ac"] = { query = "@class.outer", desc = "select OUTER part of a Class region" },
                ["ic"] = { query = "@class.inner", desc = "select INNER part of a Class region" },
                ["aa"] = { query = "@parameter.outer", desc = "select OUTER part of a Argument region" },
                ["ia"] = { query = "@parameter.inner", desc = "select INNER part of a Argument region" },
                ["am"] = { query = "@comment.outer", desc = "select OUTER part of a coMMent region" },
                ["im"] = { query = "@comment.outer", desc = "select OUTER part of a coMMent region" }, -- fake inner
                -- ["im"] = { query = "@comment.inner", desc = "select INNER part of a coMMent region" }, -- no such object
                ["ao"] = { query = "@loop.outer", desc = "select OUTER part of a lOOp region" },
                ["io"] = { query = "@loop.inner", desc = "select INNER part of a lOOp region" },
                ["an"] = { query = "@conditional.outer", desc = "select OUTER part of a coNditional region" },
                ["in"] = { query = "@conditional.inner", desc = "select INNER part of a coNditional region" },
                ["ag"] = { query = "@assignment.outer", desc = "select OUTER part of a assiGnment region" },
                ["ig"] = { query = "@assignment.outer", desc = "select OUTER part of a assiGnment region" }, -- fake inner
                -- ["ig"] = { query = "@assignment.inner", desc = "select OUTER part of a assiGnment region" }, -- no such object
                ["al"] = { query = "@assignment.lhs", desc = "select OUTER part of a assignment Lhs region" },
                ["il"] = { query = "@assignment.lhs", desc = "select OUTER part of a assignment Lhs region" }, -- nodiff inner
                ["ar"] = { query = "@assignment.rhs", desc = "select OUTER part of a assignment Rhs region" },
                ["ir"] = { query = "@assignment.rhs", desc = "select OUTER part of a assignment Rhs region" }, -- nodiff inner
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@scope", query_group = "locals", desc = "select language Scope" },
                ["is"] = { query = "@scope", query_group = "locals", desc = "select language Scope" }, -- nodiff inner
            },

            -- TODO: make 'fake' and 'nodiff' textobjects actually do something
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = false,
        },
        swap = {
            enable = true,
            swap_next = {
                [">a"] = { query = "@parameter.inner", desc = "swap with next Parameter" },
            },
            swap_previous = {
                ["<a"] = { query = "@parameter.inner", desc = "swap with previous Parameter" },
            },
        },
    },
    nvim_next = {
        enable = true,
        textobjects = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = { query = "@function.outer", desc = "Next Function start" },
                    ["]c"] = { query = "@class.outer", desc = "Next Class start" },
                    ["]a"] = { query = "@parameter.outer", desc = "Next Argument start" },
                    ["]m"] = { query = "@comment.outer", desc = "Next coMMent start" },
                    ["]o"] = { query = "@loop.outer", desc = "Next lOOp start" },
                    ["]n"] = { query = "@conditional.outer", desc = "Next coNditional start" },
                    ["]g"] = { query = "@assignment.outer", desc = "Next assiGnment start" },
                    ["]l"] = { query = "@assignment.lhs", desc = "Next Lhs start" },
                    ["]r"] = { query = "@assignment.rhs", desc = "Next Rhs start" },
                    ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                },
                goto_next_end = {
                    ["]F"] = { query = "@function.outer", desc = "Next Function end" },
                    ["]C"] = { query = "@class.outer", desc = "Next Class end" },
                    ["]A"] = { query = "@parameter.outer", desc = "Next Argument end" },
                    ["]M"] = { query = "@comment.outer", desc = "Next coMMent end" },
                    ["]O"] = { query = "@loop.outer", desc = "Next lOOp end" },
                    ["]N"] = { query = "@conditional.outer", desc = "Next coNditional end" },
                    ["]G"] = { query = "@assignment.outer", desc = "Next assiGnment end" },
                    ["]L"] = { query = "@assignment.lhs", desc = "Next Lhs end" },
                    ["]R"] = { query = "@assignment.rhs", desc = "Next Rhs end" },
                    ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "Previous Function start" },
                    ["[c"] = { query = "@class.outer", desc = "Previous Class start" },
                    ["[a"] = { query = "@parameter.outer", desc = "Previous Argument start" },
                    ["[m"] = { query = "@comment.outer", desc = "Previous coMMent start" },
                    ["[o"] = { query = "@loop.outer", desc = "Previous lOOp start" },
                    ["[n"] = { query = "@conditional.outer", desc = "Previous coNditional start" },
                    ["[g"] = { query = "@assignment.outer", desc = "Previous assiGnment start" },
                    ["[l"] = { query = "@assignment.lhs", desc = "Previous Lhs start" },
                    ["[r"] = { query = "@assignment.rhs", desc = "Previous Rhs start" },
                    ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
                },
                goto_previous_end = {
                    ["[F"] = { query = "@function.outer", desc = "Previous Function end" },
                    ["[C"] = { query = "@class.outer", desc = "Previous Class end" },
                    ["[A"] = { query = "@parameter.outer", desc = "Previous Argument end" },
                    ["[M"] = { query = "@comment.outer", desc = "Previous coMMent end" },
                    ["[O"] = { query = "@loop.outer", desc = "Previous lOOp end" },
                    ["[N"] = { query = "@conditional.outer", desc = "Previous coNditional end" },
                    ["[G"] = { query = "@assignment.outer", desc = "Previous assiGnment end" },
                    ["[L"] = { query = "@assignment.lhs", desc = "Previous Lhs end" },
                    ["[R"] = { query = "@assignment.rhs", desc = "Previous Rhs end" },
                    ["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
                },
                -- Below will go to either the start or the end, whichever is closer.
                -- Use if you want more granular movements
                -- Make it even more gradual by adding multiple queries and regex.
                goto_next = {
                    ["]]"] = { query = "@function.outer", desc = "Next function" },
                },
                goto_previous = {
                    ["[["] = { query = "@function.outer", desc = "Previous function" },
                }
            }
        },

    }
})

vim.g.skip_ts_context_commentstring_module = true
context_commentstring.setup {
    enable = true,
    enable_autocmd = false,
}

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/686#issuecomment-1745902526
-- https://codeberg.org/dnkl/foot/issues/828#issuecomment-284301
require("ibl").setup {
    scope = { highlight = highlight },
    indent = { char = "▏" },
}

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
