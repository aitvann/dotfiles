local emoji = require("telescope-emoji")

emoji.setup({
  action = function(selection)
    -- selection is a table.
    -- {name="", value="", cagegory="", description=""}
    vim.cmd("normal i" .. selection.value)
  end,
})
