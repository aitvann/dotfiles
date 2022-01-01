local mapx = require 'mapx'
mapx.setup { global = 'force' }

local M = {}

-- map(function, table)
-- e.g: map(double, {1,2,3})    -> {2,4,6}
M.map = function(func, tbl)
    local newtbl = {}
    for i, v in pairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
M.filter = function(func, tbl)
    local newtbl = {}
    for i, v in pairs(tbl) do
        if func(v) then
            newtbl[i] = v
        end
    end
    return newtbl
end

-- head(table)
-- e.g: head({1,2,3}) -> 1
M.head = function(tbl)
    return tbl[1]
end

-- tail(table)
-- e.g: tail({1,2,3}) -> {2,3}
--
-- XXX This is a BAD and ugly implementation.
-- should return the address to next porinter, like in C (arr+1)
M.tail = function(tbl)
    if table.getn(tbl) < 1 then
        return nil
    else
        local newtbl = {}
        local tblsize = table.getn(tbl)
        local i = 2
        while i <= tblsize do
            table.insert(newtbl, i - 1, tbl[i])
            i = i + 1
        end
        return newtbl
    end
end

-- foldr(function, default_value, table)
-- e.g: foldr(operator.mul, 1, {1,2,3,4,5}) -> 120
M.foldr = function(func, val, tbl)
    for _, v in pairs(tbl) do
        val = func(val, v)
    end
    return val
end

-- reduce(function, table)
-- e.g: reduce(operator.add, {1,2,3,4}) -> 10
M.reduce = function(func, tbl)
    return M.foldr(func, M.head(tbl), M.tail(tbl))
end

-- curry(f,g)
-- e.g: printf = curry(io.write, string.format)
--          -> function(...) return io.write(string.format(unpack(arg))) end
M.curry = function(f, g)
    return function(...)
        return f(g(unpack(arg)))
    end
end

-- bind1(func, binding_value_for_1st)
-- bind2(func, binding_value_for_2nd)
-- @brief
--      Binding argument(s) and generate new function.
-- @see also STL's functional, Boost's Lambda, Combine, Bind.
-- @examples
--      local mul5 = bind1(operator.mul, 5) -- mul5(10) is 5 * 10
--      local sub2 = bind2(operator.sub, 2) -- sub2(5) is 5 -2
M.bind1 = function(func, val1)
    return function(val2)
        return func(val1, val2)
    end
end
M.bind2 = function(func, val2) -- bind second argument.
    return function(val1)
        return func(val1, val2)
    end
end

-- operator table.
-- @see also python's operator module.
M.operator = {
    add = function(n, m)
        return n + m
    end,
    sub = function(n, m)
        return n - m
    end,
    mul = function(n, m)
        return n * m
    end,
    div = function(n, m)
        return n / m
    end,
    gt = function(n, m)
        return n > m
    end,
    lt = function(n, m)
        return n < m
    end,
    eq = function(n, m)
        return n == m
    end,
    le = function(n, m)
        return n <= m
    end,
    ge = function(n, m)
        return n >= m
    end,
    ne = function(n, m)
        return n ~= m
    end,
}

-- enumFromTo(from, to)
-- e.g: enumFromTo(1, 10) -> {1,2,3,4,5,6,7,8,9}
-- TODO How to lazy evaluate in Lua? (thinking with coroutine)
M.enumFromTo = function(from, to)
    local newtbl = {}
    local step = M.bind2(M.operator[(from < to) and 'add' or 'sub'], 1)
    local val = from
    while val <= to do
        table.insert(newtbl, table.getn(newtbl) + 1, val)
        val = step(val)
    end
    return newtbl
end

M.get_config_root = function()
    local vimrc = vim.fn.expand '$MYVIMRC'
    local res, _ = vimrc:gsub('/[^/]*$', '')
    return res
end

M.close_buffer_by_name = function(name)
    vim.cmd 'redir => b:cmd_buffers_output'
    vim.cmd 'silent buffers'
    vim.cmd 'redir end'

    local regex = '(%d+)......"' .. name
    local bufnr = vim.b.cmd_buffers_output:match(regex)
    if bufnr then
        vim.cmd('bdelete ' .. bufnr)
    end
end

return M
