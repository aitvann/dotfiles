-- local configs = require("nvim-treesitter.configs")
-- local context_commentstring = require('ts_context_commentstring')
-- local next_integrations = require("nvim-next.integrations")

-- next_integrations.treesitter_textobjects()

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
    callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if lang ~= nil and vim.treesitter.language.add(lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.treesitter.start()
        end
    end
})


vim.g.no_plugin_maps = true
require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
        selection_modes = function(_) return 'v' end,
        include_surrounding_whitespace = false,
    },
    move = {
        set_jumps = true,
    },

}

local select = require "nvim-treesitter-textobjects.select"
vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a Function region" })
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end,
    { silent = true, desc = "select INNER part of a Function region" })
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a Class region" })
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end,
    { silent = true, desc = "select INNER part of a Class region" })
vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a Argument region" })
vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end,
    { silent = true, desc = "select INNER part of a Argument region" })
vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@comment.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a coMMent region" })
vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@comment.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a coMMent region" }) -- fake inner for consistency
-- vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@comment.inner", "textobjects") end,
--     { silent = true, desc = "select INNER part of a coMMent region" }) -- no such object
vim.keymap.set({ "x", "o" }, "ao", function() select.select_textobject("@loop.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a lOOp region" })
vim.keymap.set({ "x", "o" }, "io", function() select.select_textobject("@loop.inner", "textobjects") end,
    { silent = true, desc = "select INNER part of a lOOp region" })
vim.keymap.set({ "x", "o" }, "an", function() select.select_textobject("@conditional.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a coNditional region" })
vim.keymap.set({ "x", "o" }, "in", function() select.select_textobject("@conditional.inner", "textobjects") end,
    { silent = true, desc = "select INNER part of a coNditional region" })
vim.keymap.set({ "x", "o" }, "ag", function() select.select_textobject("@assignment.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assiGnment region" })
vim.keymap.set({ "x", "o" }, "ig", function() select.select_textobject("@assignment.outer", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assiGnment region" }) -- fake inner for consistency
-- vim.keymap.set({ "x", "o" }, "ig", function() select.select_textobject("@assignment.inner", "textobjects") end,
--     { silent = true, desc = "select OUTER part of a assiGnment region" }) -- no such object
vim.keymap.set({ "x", "o" }, "al", function() select.select_textobject("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assignment Lhs region" })
vim.keymap.set({ "x", "o" }, "il", function() select.select_textobject("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assignment Lhs region" }) -- nodiff inner
vim.keymap.set({ "x", "o" }, "ar", function() select.select_textobject("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assignment Rhs region" })
vim.keymap.set({ "x", "o" }, "ir", function() select.select_textobject("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "select OUTER part of a assignment Rhs region" }) -- nodiff inner
vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@scope", "locals") end,
    { silent = true, desc = "select language Scope" })
vim.keymap.set({ "x", "o" }, "is", function() select.select_textobject("@scope", "locals") end,
    { silent = true, desc = "select language Scope" }) -- nodiff inner

-- local swap = require "nvim-treesitter-textobjects.swap"
-- vim.keymap.set({ "n" }, ">a", function() swap.swap_next "@parameter.inner" end,
--     { silent = true, desc = "swap with next Parameter" })
-- vim.keymap.set({ "n" }, "<a", function() swap.swap_previous "@parameter.inner" end,
--     { silent = true, desc = "swap with previous Parameter" })

local move = require "nvim-treesitter-textobjects.move"

vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
    { silent = true, desc = "Next Function start" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end,
    { silent = true, desc = "Next Class start" })
vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.outer", "textobjects") end,
    { silent = true, desc = "Next Argument start" })
vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@comment.outer", "textobjects") end,
    { silent = true, desc = "Next coMMent start" })
vim.keymap.set({ "n", "x", "o" }, "]o", function() move.goto_next_start("@loop.outer", "textobjects") end,
    { silent = true, desc = "Next lOOp start" })
vim.keymap.set({ "n", "x", "o" }, "]n", function() move.goto_next_start("@conditional.outer", "textobjects") end,
    { silent = true, desc = "Next coNditional start" })
vim.keymap.set({ "n", "x", "o" }, "]g", function() move.goto_next_start("@assignment.outer", "textobjects") end,
    { silent = true, desc = "Next assiGnment start" })
vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "Next Lhs start" })
vim.keymap.set({ "n", "x", "o" }, "]r", function() move.goto_next_start("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "Next Rhs start" })
vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@scope", "locals") end,
    { silent = true, desc = "Next scope" })

vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end,
    { silent = true, desc = "Next Function end" })
vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end,
    { silent = true, desc = "Next Class end" })
vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.outer", "textobjects") end,
    { silent = true, desc = "Next Argument end" })
vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@comment.outer", "textobjects") end,
    { silent = true, desc = "Next coMMent end" })
vim.keymap.set({ "n", "x", "o" }, "]O", function() move.goto_next_end("@loop.outer", "textobjects") end,
    { silent = true, desc = "Next lOOp end" })
vim.keymap.set({ "n", "x", "o" }, "]N", function() move.goto_next_end("@conditional.outer", "textobjects") end,
    { silent = true, desc = "Next coNditional end" })
vim.keymap.set({ "n", "x", "o" }, "]G", function() move.goto_next_end("@assignment.outer", "textobjects") end,
    { silent = true, desc = "Next assiGnment end" })
vim.keymap.set({ "n", "x", "o" }, "]L", function() move.goto_next_end("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "Next Lhs end" })
vim.keymap.set({ "n", "x", "o" }, "]R", function() move.goto_next_end("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "Next Rhs end" })
vim.keymap.set({ "n", "x", "o" }, "]S", function() move.goto_next_end("@scope", "locals") end,
    { silent = true, desc = "Next scope" })

vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
    { silent = true, desc = "Previous Function start" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end,
    { silent = true, desc = "Previous Class start" })
vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.outer", "textobjects") end,
    { silent = true, desc = "Previous Argument start" })
vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@comment.outer", "textobjects") end,
    { silent = true, desc = "Previous coMMent start" })
vim.keymap.set({ "n", "x", "o" }, "[o", function() move.goto_previous_start("@loop.outer", "textobjects") end,
    { silent = true, desc = "Previous lOOp start" })
vim.keymap.set({ "n", "x", "o" }, "[n", function() move.goto_previous_start("@conditional.outer", "textobjects") end,
    { silent = true, desc = "Previous coNditional start" })
vim.keymap.set({ "n", "x", "o" }, "[g", function() move.goto_previous_start("@assignment.outer", "textobjects") end,
    { silent = true, desc = "Previous assiGnment start" })
vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "Previous Lhs start" })
vim.keymap.set({ "n", "x", "o" }, "[r", function() move.goto_previous_start("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "Previous Rhs start" })
vim.keymap.set({ "n", "x", "o" }, "[s", function() move.goto_previous_start("@scope", "local") end,
    { silent = true, desc = "Previous scope" })

vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end,
    { silent = true, desc = "Previous Function end" })
vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end,
    { silent = true, desc = "Previous Class end" })
vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.outer", "textobjects") end,
    { silent = true, desc = "Previous Argument end" })
vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@comment.outer", "textobjects") end,
    { silent = true, desc = "Previous coMMent end" })
vim.keymap.set({ "n", "x", "o" }, "[O", function() move.goto_previous_end("@loop.outer", "textobjects") end,
    { silent = true, desc = "Previous lOOp end" })
vim.keymap.set({ "n", "x", "o" }, "[N", function() move.goto_previous_end("@conditional.outer", "textobjects") end,
    { silent = true, desc = "Previous coNditional end" })
vim.keymap.set({ "n", "x", "o" }, "[G", function() move.goto_previous_end("@assignment.outer", "textobjects") end,
    { silent = true, desc = "Previous assiGnment end" })
vim.keymap.set({ "n", "x", "o" }, "[L", function() move.goto_previous_end("@assignment.lhs", "textobjects") end,
    { silent = true, desc = "Previous Lhs end" })
vim.keymap.set({ "n", "x", "o" }, "[R", function() move.goto_previous_end("@assignment.rhs", "textobjects") end,
    { silent = true, desc = "Previous Rhs end" })
vim.keymap.set({ "n", "x", "o" }, "[S", function() move.goto_previous_end("@scope", "locals") end,
    { silent = true, desc = "Previous scope" })

-- Go to either the start or the end, whichever is closer.
-- Use if you want more granular movements
vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next("@function.outer", "textobjects") end,
    { silent = true, desc = "Next function" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous("@function.outer", "textobjects") end,
    { silent = true, desc = "Previous function" })

local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

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
