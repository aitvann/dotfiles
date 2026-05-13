local utils = require('utils')

vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('current_location', { clear = true }),
    desc = "Integration with current-location script: write current location on every location change",
    callback = function(args)
        local filepath = args.file
        -- Writing pids for server and every UI attached to it
        -- Usefull when UI process is not a child of server process (like after :restart)
        if filepath ~= "" and vim.fn.filereadable(filepath) == 1 then
            -- Race condition?
            vim.system(
                vim.iter({ "current-location", "write", "nvim", filepath, utils.get_ui_pids(), vim.uv.os_getpid(),
                    "--nvim-pipe", vim.v.servername }):flatten():totable(),
                { text = true },
                function(result)
                    if result.code ~= 0 then
                        vim.notify("Error writing current location (" .. result.code .. "): " .. result.stderr,
                            vim.log.levels.ERROR)
                    end
                end
            )
        end
    end,
})
