# NeoVim Config

This is my NeoVim config

## Mappings

These lists were generated using [this][format_key] function so some mapping
might be missing for some reasone. But imagine jumping through your entire configuration,
copying and pasting all the mappings manually

### Normal Mode

- `<BS>` - close buffer
- `<Del>` - CLOSE window
- `<S-Del>` - CLOSE tab
- `<C-D>` - require('neoscroll').scroll(vim.wo.scroll, true, 250)
- `<C-E>` - require('neoscroll').scroll(0.10, false, 100)
- `<C-U>` - require('neoscroll').scroll(-vim.wo.scroll, true, 250)
- `<C-Y>` - require('neoscroll').scroll(-0.10, false, 100)
- `<Up>` - scroll UP
- `<Down>` - scroll DOWN
- `<Left>` - scroll horizontally to the LEFT
- `<Right>` - scroll horizontally to the RIGHT
- `<S-Up>` - move window divider UP
- `<S-Down>` - move window divider DOWN
- `<S-Left>` - move window divider LEFT
- `<S-Right>` - move window divider RIGHT
- `<Tab>` - cycle trought buffers forward
- `<S-Tab>` - cycle trought buffers backward
- `<C-H>` - no search Highlight
- `<C-R>` - <C-W>L
- `U` - redo
- `Y` - y$
- `]`
  - `]d` - GOTO NEXT diagnostics
  - `]h` - GOTO NEXT Hunk
- `[`
  - `[d` - GOTO PREVIOUS diagnostics
  - `[h` - GOTO PREVIOUS Hunk
- `\`
  - `\E` - Evaluate motion
  - `\e`
    - `\e!` - Evaluate form and replace with result
    - `\eb` - Evaluate buffer
    - `\ee` - Evaluate current form
    - `\ef` - Evaluate file
    - `\em` - Evaluate marked form
    - `\ep` - Evaluate previous evaluation
    - `\er` - Evaluate root form
    - `\ew` - Evaluate word
    - `\ec`
      - `\ece` - Evaluate current form and comment result
      - `\ecr` - Evaluate root form and comment result
      - `\ecw` - Evaluate word and comment result
  - `\g`
    - `\gd` - Get definition under cursor
  - `\l`
    - `\le` - Open log in new buffer
    - `\lg` - Toggle log buffer
    - `\ll` - Jump to latest part of log
    - `\lq` - Close all visible log windows
    - `\lr` - Soft reset log
    - `\lR` - Hard reset log
    - `\ls` - Open log in new horizontal split window
    - `\lt` - Open log in new tab
    - `\lv` - Open log in new vertical split window
  - `\r`
    - `\ra` - Executes the ConjureLuaResetAllEnvs command
    - `\rr` - Executes the ConjureLuaResetEnv command
- `<leader>`
  - `<leader>;` - open terminal
  - `<leader>a` - show code Actions
  - `<leader>e` - open file Explorer
  - `<leader>f` - Format current buffer
  - `<leader>i` - Inspect node under cursor
  - `<leader>M` - show PROJECT diagnostics (Messages)
  - `<leader>m` - show CURRENT LINE diagnostics (Messages)
  - `<leader>O` - create line BELOW in normal mode
  - `<leader>o` - create line ABOVE in normal mode
  - `<leader>p` - swap with next Parameter
  - `<leader>P` - swap with previous Parameter
  - `<leader>q` - Quite from current editor
  - `<leader>Q` - Quite from editor
  - `<leader>R` - COPLETELY Rename object under cursor
  - `<leader>r` - PARTIALLY Rename object under cursor
  - `<leader>w` - Write current buffer
  - `<leader>g` - Git
    - `<leader>gb` - open Git Branches
    - `<leader>gm` - open Git coMMits
    - `<leader>gs` - open Git Status
  - `<leader>t` - Toggling
    - `<leader>tc` - Toggle auto-Comment
    - `<leader>tf` - Toggle Formatting on save
- `c`
  - `cS` - <Plug>CSurround
  - `cs` - <Plug>Csurround
- `d`
  - `ds` - <Plug>Dsurround
- `g` - Go to
  - `gb` - Go to a buffer
  - `gc` - Comment toggle linewise
  - `gd` - Go to Definitions
  - `gD` - Go to type Definitions
  - `gh` - GO to the LEFT window
  - `gj` - GO to the BELOW window
  - `gJ` - Go to Jump point
  - `gk` - GO to the ABOVE window
  - `gl` - GO to the RIGHT window
  - `gP` - open Projects
  - `gr` - Go to References
  - `gS` - Go to WORKSPACE Symbols
  - `gs` - Go to DOCUMENT Symbols
  - `gW` - Go to Word in the PROJECT
  - `gw` - Go to Word in the CURRENT buffer
  - `gm` - Go Mirror window
    - `gmh` - GO to the LEFT window mirroring the current window
    - `gmj` - GO to the BELOW window mirroring the current window
    - `gmk` - GO to the ABOVE window mirroring the current window
    - `gml` - GO to the RIGHT window mirroring the current window
  - `gp` - Go Pull window
    - `gph` - Go to the LEFT, Pulling the current window with you
    - `gpj` - Go DOWN, Pulling the current window with you
    - `gpk` - Go UP, Pulling the current window with you
    - `gpl` - Go to the RIFHT, Pulling the current window with you
- `v`
  - `vv` - V
- `y`
  - `yS` - <Plug>YSurround
  - `ys` - <Plug>Ysurround

### Visual Mode

- `<leader>`
  - `<leader>f` - Format selected range
  - `<leader>h` - Hunk
    - `<leader>hs` - Stage selected Hunks
    - `<leader>hx` - RESET selected Hunks
- `g`
  - `gc` - Go Comment
