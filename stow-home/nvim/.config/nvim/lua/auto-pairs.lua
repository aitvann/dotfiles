local npairs = require("nvim-autopairs")
local ts_conds = require("nvim-autopairs.ts-conds")
local Rule = require('nvim-autopairs.rule')
local cond = require("nvim-autopairs.conds")

npairs.setup({
    check_ts = true,
    disable_filetype = { "spectre_panel" },
    enable_check_bracket_line = false,
})

npairs.get_rules("'")[1].not_filetypes = {
    'nix',

    -- `'` is used for char values but those are used much more rarely then lifetimes
    'rust',

    -- Lisps
    'clojure', 'scheme', 'lisp'
}

-- Alternatively it's possible to use TS to detect type arguements
-- but it requires function/struct to be fully defined
-- npairs.get_rule("'")[2]:with_pair(ts_conds.is_not_ts_node({ "type_arguments", "bounded_type" }))

-- Sources:
-- - https://github.com/stasjok/dotfiles/blob/cee8edc74604dba30fd50b48214b4be32bf82328/nvim/autopairs/pairs.lua

---Check if entered character matches `end_pair`'s first char.
local function char_matches_end_pair(opts)
    return opts.char == opts.next_char:sub(1, 1)
end

---Returns a simple function that checks if cursor is not in a single-line comment.
local function not_in_comment(comment_char)
    local comment = comment_char or "#"
    ---Check if cursor is in single-line comment.
    return function(opts)
        if opts.line:sub(1, opts.col):find(comment, 1, true) then
            return false
        end
    end
end

---A condition for Rust Generic Parameter <>
local function is_rust_generic_param(opts)
    local identifier = "[%w_]+"
    local str = opts.line:sub(1, opts.col - 1)
    if
        str:find(":%s*" .. identifier .. "%s*$")              -- var: Type|
        or str:find(":%s*impl%s+" .. identifier .. "%s*$")    -- var: impl Type|
        or str:find("->%s*" .. identifier .. "%s*$")          -- f() -> Type|
        or str:find("->%s*impl%s+" .. identifier .. "%s*$")   -- f() -> impl Type|
        or str:find("fn%s+" .. identifier .. "%s*$")          -- fn fname|
        or str:find("struct%s+" .. identifier .. "%s*$")      -- struct Name|
        or str:find("enum%s+" .. identifier .. "%s*$")        -- enum Name|
        or str:find("impl%s*$")                               -- impl|
        or str:find("impl%s+" .. identifier .. "%s*$")        -- impl Name|
        or str:find("impl%s*%b<>%s*" .. identifier .. "%s*$") -- impl<T> Name|
        or str:find("trait%s+" .. identifier .. "%s*$")       -- trait Name|
        or str:find("type%s+" .. identifier .. "%s*$")        -- type Name|
        or str:find("::%s*$")                                 -- turbofish::|
    then
        return true
    end
    return false
end

--- A condition for Rust closure parameters
local function is_rust_closure(opts)
    local str = opts.line:sub(1, opts.col - 1)
    if
        str:find("move%s+$")    -- move |
        or str:find("=%s*$")    -- let statement: = |
        or str:find("[(,]%s*$") -- function parameters: (| or , |
    then
        return true
    else
        return false
    end
end

npairs.add_rules({
    -- Lua
    Rule("=", ",", "lua")
        :with_pair(cond.not_after_regex("%s?}", 2), nil)
        :with_pair(
            ts_conds.is_ts_node({ "table_constructor", "field", "bracket_index_expression" }),
            nil
        )
        :with_cr(cond.none())
        :with_move(char_matches_end_pair),

    -- Nix
    Rule("=", ";", "nix")
        :with_pair(not_in_comment())
        :with_pair(ts_conds.is_not_in_context())
        :with_pair(ts_conds.is_not_ts_node({
            "source",
            "string",
            "indented_string_expression",
            "string_fragment",
        }))
        :with_cr(cond.none())
        :with_move(char_matches_end_pair),
    Rule("'", "'", "nix")
        :with_pair(cond.not_before_regex("[^%s]"))
        :with_pair(cond.not_after_regex([=[[%w%%%'%[%"%.%`%$]]=])) -- Upstream default
        :with_pair(ts_conds.is_ts_node({ "indented_string_expression", "string_fragment" }))
        :with_move(cond.not_after_text("''"))
        :with_move(char_matches_end_pair),
    Rule("''", "''", "nix")
        :with_pair(not_in_comment())
        :with_pair(ts_conds.is_not_in_context())
        :with_pair(ts_conds.is_not_ts_node({
            "source",
            "string",
            "indented_string_expression",
            "string_fragment",
        }))
        :with_pair(cond.not_before_text("''"))
        :with_move(char_matches_end_pair),

    -- Rust
    Rule('r#"', '"#', "rust"),
    Rule("<", ">", "rust")
        :with_pair(is_rust_generic_param)
        :with_move(char_matches_end_pair)
        :with_cr(cond.none()),
    Rule("|", "|", "rust")
        :with_pair(is_rust_closure)
        :with_move(char_matches_end_pair)
        :with_cr(cond.none()),
    -- Does not work for some reason
    Rule("=", ";", "rust")
        :with_pair(function(opts)
            return (
                cond.before_regex("let%s+[^=]+$", 100)(opts)
                or cond.before_regex("type%s+[^=]+$", 100)(opts)
            ) and cond.after_regex("^%s*$", 10)(opts)
        end)
        :with_move(char_matches_end_pair)
        :with_cr(cond.none()),
})
