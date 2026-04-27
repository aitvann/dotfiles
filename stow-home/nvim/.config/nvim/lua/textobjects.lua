local ai = require("mini.ai")
local surround = require("mini.surround")
local rm = require("repeatable_move")

local ts_input = surround.gen_spec.input.treesitter
local custom_surroundings = {
    -- markdown Strike
    s = { input = { "%~%~().-()%~%~" }, output = { left = "~~", right = "~~" }, },
    -- markdown Italic
    i = { input = { "%*().-()%*" }, output = { left = "*", right = "*" }, },
    -- markdown BOLD (highlight with Yellow marker)
    y = { input = { '%*%*().-()%*%*' }, output = { left = "**", right = "**" }, },
    -- TODO: jump mappings conflict with diagnostics jump mappings
    -- markdown coDe block
    d = { input = { '```[%w_%s]*\n().-()%s*```' }, output = { left = "```\n", right = "\n```" }, },
    -- markdown LINK
    x = { input = { "%[().-()%]%(.-%)" }, output = { left = "[", right = "]()" }, },
    -- Zettelkasten links
    z = { input = { '%[%[().-()%]%]' }, output = { left = "[[", right = "]]" }, },

    -- fUnction call
    u = { input = ts_input({ outer = '@call.outer', inner = '@call.inner' }) },
}

local spec_treesitter = ai.gen_spec.treesitter
local treesitter_textobjects = {
    f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
    a = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
    m = spec_treesitter({ a = '@comment.outer', i = '@comment.outer' }), -- no `.inner`, using fake one
    o = spec_treesitter({ a = '@loop.outer', i = '@loop.inner' }),
    n = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
    g = spec_treesitter({ a = '@assignment.outer', i = '@assignment.outer' }), -- no `.inner`, using fake one
    l = spec_treesitter({ a = '@assignment.lhs', i = '@assignment.lhs' }),     -- `a` and `i` are the same
    r = spec_treesitter({ a = '@assignment.rhs', i = '@assignment.rhs' }),     -- `a` and `i` are the same
    -- TODO: conflicts with Strike surrounding
    -- TODO: figure out a way to specify query group `locals`
    -- s = spec_treesitter({ a = '@scope', i = '@scope' }), -- `a` and `i` are the same

    -- overriding surroundings
    u = spec_treesitter({ a = '@call.outer', i = '@call.inner' }),
}

-- local search_method = 'cover_or_next'
local search_method = 'cover'

local surroundings_textobjects = vim.iter(custom_surroundings)
    :map(function(cs) return { [cs] = custom_surroundings[cs].input } end)
    :fold({}, function(acc, t) return vim.tbl_extend("force", acc, t) end)

local custom_textobjects = {}
custom_textobjects = vim.tbl_extend('force', custom_textobjects, surroundings_textobjects)
custom_textobjects = vim.tbl_extend('force', custom_textobjects, treesitter_textobjects)

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

local selopts = function(search_method)
    -- NOTE: might have to specify `vis_mode`
    return { search_method = search_method, n_times = vim.v.count1, reference_region = get_visual_region() }
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

local goto_characters = { 'b', 'q', '?', 't' }
vim.list_extend(goto_characters, vim.tbl_keys(custom_textobjects))

for _, char in ipairs(goto_characters) do
    local opts = function(sm) return { n_times = vim.v.count1, search_method = 'cover_or_' .. sm } end

    local next = function() ai.move_cursor('left', 'a', char, opts('next')) end
    local prev = function() ai.move_cursor('left', 'a', char, opts('prev')) end
    next, prev = rm.make_repeatable_move_pair(next, prev)

    vim.keymap.set({ "n", "x", "o" }, "]" .. char, next,
        { silent = true, desc = "GOTO NEXT START of textobject " .. char })
    vim.keymap.set({ "n", "x", "o" }, "[" .. char, prev,
        { silent = true, desc = "GOTO PREVIOUS START of textobject " .. char })

    local next = function() ai.move_cursor('right', 'a', char, opts('next')) end
    local prev = function() ai.move_cursor('right', 'a', char, opts('prev')) end
    next, prev = rm.make_repeatable_move_pair(next, prev)

    vim.keymap.set({ "n", "x", "o" }, "]" .. string.upper(char), next,
        { silent = true, desc = "GOTO NEXT END of textobject " .. char })
    vim.keymap.set({ "n", "x", "o" }, "[" .. string.upper(char), prev,
        { silent = true, desc = "GOTO PREVIOUS END of textobject " .. char })
end
