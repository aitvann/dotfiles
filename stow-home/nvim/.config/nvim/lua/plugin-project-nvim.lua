-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

local hijack_netrw = function()
    local netrw_bufname

    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("telescope-on-enter", { clear = true }),
        pattern = "*",
        callback = function()
            vim.schedule(function()
                if vim.bo[0].filetype == "netrw" then
                    return
                end
                local bufname = vim.api.nvim_buf_get_name(0)
                if vim.fn.isdirectory(bufname) == 0 then
                    _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
                    return
                end

                -- prevents reopening of file-browser if exiting without selecting a file
                if netrw_bufname == bufname then
                    netrw_bufname = nil
                    return
                else
                    netrw_bufname = bufname
                end

                -- ensure no buffers remain with the directory name
                vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

                require("telescope.builtin").find_files({
                    search_dirs = { netrw_bufname }
                })
            end)
        end,
        desc = "telescope replacement for netrw",
    })
end

hijack_netrw()
