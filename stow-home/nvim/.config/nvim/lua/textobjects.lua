local ai = require("mini.ai")
local surround = require("mini.surround")
local rm = require("repeatable_move")

-- --------------------------------------------------------------------------------
-- Library
-- --------------------------------------------------------------------------------

local make_custom_surroundings = function(specs)
    local treesitter_surroundings_specs = specs.treesitter_surroundings and
        vim.iter(pairs(specs.treesitter_surroundings))
        :map(function(id, spec)
            return {
                [id] = spec and
                    { input = surround.gen_spec.input.treesitter(spec.input), output = spec.output }
            }
        end)
        :fold({}, function(acc, t) return vim.tbl_extend("force", acc, t) end) or {}

    local custom_surroundings = {}
    custom_surroundings = vim.tbl_extend('force', custom_surroundings, specs.regex_surroundings or {})
    custom_surroundings = vim.tbl_extend('force', custom_surroundings, treesitter_surroundings_specs)

    return custom_surroundings
end

local make_custom_textobjects = function(specs)
    local surroundings_textobjects = specs.regex_surroundings and
        vim.iter(pairs(specs.regex_surroundings))
        :map(function(id, spec) return { [id] = spec and spec.input } end)
        :fold({}, function(acc, t) return vim.tbl_extend("force", acc, t) end) or {}

    local treesitter_surroundings_textobjects = specs.treesitter_surroundings and
        vim.iter(pairs(specs.treesitter_surroundings))
        :map(function(id, spec)
            return {
                [id] = spec and
                    ai.gen_spec.treesitter({ a = spec.input.outer, i = spec.input.inner })
            }
        end)
        :fold({}, function(acc, t) return vim.tbl_extend("force", acc, t) end) or {}

    local treesitter_textobjects_specs = specs.treesitter_textobjects and
        vim.iter(pairs(specs.treesitter_textobjects))
        :map(function(id, spec) return { [id] = spec and ai.gen_spec.treesitter({ a = spec.outer, i = spec.inner }) } end)
        :fold({}, function(acc, t) return vim.tbl_extend("force", acc, t) end) or {}

    local custom_textobjects = {}
    custom_textobjects = vim.tbl_extend('force', custom_textobjects, surroundings_textobjects)
    custom_textobjects = vim.tbl_extend('force', custom_textobjects, treesitter_surroundings_textobjects)
    custom_textobjects = vim.tbl_extend('force', custom_textobjects, specs.regex_textobjects or {})
    custom_textobjects = vim.tbl_extend('force', custom_textobjects, treesitter_textobjects_specs)

    return custom_textobjects
end


-- --------------------------------------------------------------------------------
-- Configuration
-- --------------------------------------------------------------------------------

-- local search_method = 'cover_or_next'
local search_method = 'cover'

local regex_surroundings = {
    -- Unable to disable default 'function call' surrounding.
    -- Even tho a better treesitter one will be used instead
    -- with a different id
    -- Only replacments for builtin surroundings can be disabled
    -- f = false,

    -- markdown Strike
    s = { input = { "%~%~().-()%~%~" }, output = { left = "~~", right = "~~" } },
    -- markdown Italic
    i = { input = { "%*().-()%*" }, output = { left = "*", right = "*" } },
    -- markdown BOLD (highlight with Yellow marker)
    y = { input = { '%*%*().-()%*%*' }, output = { left = "**", right = "**" } },
    ["`"] = { input = { '%`().-()%`' }, output = { left = "`", right = "`" } },
    -- markdown LINK
    x = { input = { "%[().-()%]%(.-%)" }, output = { left = "[", right = "]()" } },
    -- Zettelkasten links
    z = { input = { '%[%[().-()%]%]' }, output = { left = "[[", right = "]]" } },
}

local treesitter_surroundings = {
    -- Won't work bacause `markdown_inline` parser is not loaded in some cases.
    -- See [issue](https://github.com/nvim-mini/mini.nvim/issues/2397#issuecomment-4345953431)
    -- i = { input = { outer = '@emphasis.outer', inner = '@emphasis.inner' }, output = { left = "*", right = "*" } },
    -- y = { input = { outer = '@strong_emphasis.outer', inner = '@strong_emphasis.inner' }, output = { left = "**", right = "**" } },

    -- markdown coDe block
    d = { input = { outer = '@cell.outer', inner = '@cell.inner' }, output = { left = "```\n", right = "\n```" } },
    -- fUnction call
    u = {
        input = { outer = '@call.outer', inner = '@call.inner' },
        -- Copy from mini.ai/lua/mini/surround.lua
        output = function()
            local fun_name = surround.user_input('Function name')
            if fun_name == nil then return nil end
            return { left = ('%s('):format(fun_name), right = ')' }
        end,
    },
}

local treesitter_surroundings_quote = {
    q = { input = { outer = '@quoted.outer', inner = '@quoted.inner' }, output = { left = "\"", right = "\"" } },
}

local regex_textobjects = {
    -- TODO: Make it smart enough
    -- See https://github.com/nvim-mini/mini.nvim/issues/151#issuecomment-1401626377
    -- v = { { '%f[%w]()%w+()_', '%f[%u]()()%w*[%l%d]()()%u' } },
}

local treesitter_textobjects = {
    f = { outer = '@function.outer', inner = '@function.inner' },       -- Funcition
    c = { outer = '@class.outer', inner = '@class.inner' },             -- Class
    a = { outer = '@parameter.outer', inner = '@parameter.inner' },     -- parameter (Argument)
    m = { outer = '@comment.outer', inner = '@comment.outer' },         -- coMMent. No `.inner`, using fake one
    o = { outer = '@loop.outer', inner = '@loop.inner' },               -- lOOp
    n = { outer = '@conditional.outer', inner = '@conditional.inner' }, -- coNditional
    g = { outer = '@assignment.outer', inner = '@assignment.outer' },   -- assiGnment. No `.inner`, using fake one
    l = { outer = '@assignment.lhs', inner = '@assignment.lhs' },       -- Lhs. `a` and `i` are the same
    r = { outer = '@assignment.rhs', inner = '@assignment.rhs' },       -- Rhs. `a` and `i` are the same
}

-- --------------------------------------------------------------------------------
-- Setup
-- --------------------------------------------------------------------------------

local custom_textobjects = make_custom_textobjects({
    regex_surroundings = regex_surroundings,
    treesitter_surroundings = treesitter_surroundings,
    regex_textobjects = regex_textobjects,
    treesitter_textobjects = treesitter_textobjects,
})

ai.setup({
    custom_textobjects = custom_textobjects,

    mappings = {
        -- Mappings could look like this...
        -- around_next = 'aj',
        -- inside_next = 'ij',
        -- around_last = 'ak',
        -- inside_last = 'ik',
        -- ... but they are defined manually instead to be repeatable
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',

        -- Disabling universal 'goto textobject' mappings since
        -- those are too much to type and no ability to jump backward.
        -- Using specialized keymappings for the most common textobjects
        goto_left = '',
        goto_right = '',
    },

    search_method = search_method,

    -- Making sure it covers the entire screen.
    -- From the very top to the very bottom
    n_lines = 100,
    silent = true,
})


local custom_surroundings = make_custom_surroundings({
    regex_surroundings = regex_surroundings,
    treesitter_surroundings = treesitter_surroundings
})

surround.setup({
    custom_surroundings = custom_surroundings,

    mappings = {
        add = 's',
        delete = 'ds',
        find = '',
        replace = 'cs',
        -- Disabling 'jump' mappings, using textobjects jumps instead
        find_left = '',
        highlight = '',

        suffix_next = 'j',
        suffix_last = 'k',
    },

    search_method = search_method,

    -- Making sure it covers the entire screen.
    -- From the very top to the very bottom
    n_lines = 100,
    silent = true,
})


vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_quote_surrounding", { clear = true }),
    desc = "Enable TreeSitter-powered quote textobject for supported languages",
    pattern = {
        "lua", "rust", "clojure", "nix",
        -- Does not work for some reason
        -- "sh"
    },
    callback = function(event)
        vim.b[event.buf].miniai_config = {
            custom_textobjects = make_custom_textobjects({
                treesitter_surroundings = treesitter_surroundings_quote
            }),
        }

        vim.b[event.buf].minisurround_config = {
            custom_surroundings = make_custom_surroundings({
                treesitter_surroundings = treesitter_surroundings_quote
            }),
        }
    end
})

-- --------------------------------------------------------------------------------
-- Select
-- --------------------------------------------------------------------------------

local select_characters = { "(", "[", "{", "<", ")", "]", "}", ">", "b", "\"", "'", "q", "?", "t", }
vim.list_extend(select_characters, vim.tbl_keys(custom_textobjects))

-- Copy from mini.ai/lua/mini/ai.lua
local is_visual_mode = function(mode)
    mode = mode or vim.fn.mode()
    -- '\22' is an escaped `<C-v>`
    return mode == 'v' or mode == 'V' or mode == '\22', mode
end

-- Copy from mini.ai/lua/mini/ai.lua
local get_visual_region = function()
    local is_vis, _ = is_visual_mode()
    if not is_vis then return end
    local res = {
        from = { line = vim.fn.line('v'), col = vim.fn.col('v') },
        to = { line = vim.fn.line('.'), col = vim.fn.col('.') },
    }
    if res.from.line > res.to.line or (res.from.line == res.to.line and res.from.col > res.to.col) then
        res = { from = res.to, to = res.from }
    end
    return res
end

local selopts = function(sm)
    -- NOTE: might have to specify `vis_mode`
    return { search_method = sm, n_times = vim.v.count1, reference_region = get_visual_region() }
end

for _, char in ipairs(select_characters) do
    local select_inside_next = function() ai.select_textobject('i', char, selopts('next')) end
    local select_inside_prev = function() ai.select_textobject('i', char, selopts('prev')) end
    select_inside_next, select_inside_prev = rm.make_repeatable_move_pair(select_inside_next, select_inside_prev)
    vim.keymap.set({ "x", "o" }, "ij" .. char, select_inside_next,
        { silent = true, desc = "select Inside NEXT " .. char .. " textobject" })
    vim.keymap.set({ "x", "o" }, "ik" .. char, select_inside_prev,
        { silent = true, desc = "select Inside PREVIOUS " .. char .. " textobject" })

    local select_around_next = function() ai.select_textobject('a', char, selopts('next')) end
    local select_around_prev = function() ai.select_textobject('a', char, selopts('prev')) end
    select_around_next, select_around_prev = rm.make_repeatable_move_pair(select_around_next, select_around_prev)
    vim.keymap.set({ "x", "o" }, "aj" .. char, select_around_next,
        { silent = true, desc = "select Around NEXT " .. char .. " textobject" })
    vim.keymap.set({ "x", "o" }, "ak" .. char, select_around_prev,
        { silent = true, desc = "select Around PREVIOUS " .. char .. " textobject" })

    local select_inside = function() ai.select_textobject('i', char, selopts(search_method)) end
    local select_inside_prev = search_method == 'cover_or_next' and
        function() ai.select_textobject('i', char, selopts("prev")) end or
        function() print('noop is called') end
    select_inside, _ = rm.make_repeatable_move_pair(select_inside, select_inside_prev)
    vim.keymap.set({ "x", "o" }, "i" .. char, select_inside,
        { silent = true, desc = "select Inside CURRENT " .. char .. " textobject" })

    local select_around = function() ai.select_textobject('a', char, selopts(search_method)) end
    local select_around_prev = search_method == 'cover_or_next' and
        function() ai.select_textobject('a', char, selopts("prev")) end or
        function() print('noop is called') end
    select_around, _ = rm.make_repeatable_move_pair(select_around, select_around_prev)
    vim.keymap.set({ "x", "o" }, "a" .. char, select_around,
        { silent = true, desc = "select Around CURRENT " .. char .. " textobject" })
end

-- --------------------------------------------------------------------------------
-- Goto
-- --------------------------------------------------------------------------------

local goto_ids = { '(', '[', '{', '<', 'b', '"', '\'', 'q', '?', 't' }
vim.list_extend(goto_ids, vim.tbl_keys(custom_textobjects))

local get_textobject_end_id = function(start_id)
    local upper_case_variant = string.upper(start_id)
    local pairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
        ['<'] = '>',
    }

    local pair = pairs[start_id]
    if start_id ~= upper_case_variant then
        return upper_case_variant
    elseif pair then
        return pair
    else
        return start_id
    end
end

for _, id in ipairs(goto_ids) do
    local opts = function(sm) return { n_times = vim.v.count1, search_method = sm } end

    -- Defining GOTO NEXT END first so that GOTO NEXT START will take priority
    -- is cases when there is no upper case variant for a character (e.g. ` textobject)
    -- Ideally we would jump to the closest side in this case but this feature
    -- is not planned: https://github.com/nvim-mini/mini.nvim/issues/2398#issuecomment-4353212366

    local end_id = get_textobject_end_id(id)
    local next = function() ai.move_cursor('right', 'a', id, opts('cover_or_next')) end
    local prev = function() ai.move_cursor('right', 'a', id, opts('prev')) end
    next, prev = rm.make_repeatable_move_pair(next, prev)

    vim.keymap.set({ "n", "x", "o" }, "]" .. end_id, next,
        { silent = true, desc = "GOTO NEXT END of textobject " .. id })
    vim.keymap.set({ "n", "x", "o" }, "[" .. end_id, prev,
        { silent = true, desc = "GOTO PREVIOUS END of textobject " .. id })

    local next = function() ai.move_cursor('left', 'a', id, opts('next')) end
    local prev = function() ai.move_cursor('left', 'a', id, opts('cover_or_prev')) end
    next, prev = rm.make_repeatable_move_pair(next, prev)

    vim.keymap.set({ "n", "x", "o" }, "]" .. id, next,
        { silent = true, desc = "GOTO NEXT START of textobject " .. id })
    vim.keymap.set({ "n", "x", "o" }, "[" .. id, prev,
        { silent = true, desc = "GOTO PREVIOUS START of textobject " .. id })
end
