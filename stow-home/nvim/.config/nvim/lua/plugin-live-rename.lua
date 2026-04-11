require("live-rename").setup({
    keys = {
        submit = {
            { "n", "<cr>" },
            { "v", "<cr>" },
            { "i", "<cr>" },
        },
        cancel = {
            { "n", "<esc>" },
            { "n", "q" },
        },
    },
    hl = {
        current = "CurSearch",
        others = "Search",
    },
})
