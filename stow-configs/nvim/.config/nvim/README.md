# NeoVim Config

This is my NeoVim config

## Mappings

The list isn't full, only the most interesting mappings are presented.
The fun part of this is that these lists were generated using [this][format_key] function.
Imagine jumping through your entire configuration,
copying and pasting all the mappings manually

### Any mode

* `<leader>`
  * `<leader>s`
    * `<leader>sc` - SClose
    * `<leader>sd` - SDelete
    * `<leader>sl` - SLoad
    * `<leader>ss` - SSave

### Normal Mode

* `<leader>`
  * `<leader>;` - open terminal
  * `<leader>e` - open file Explorer
  * `<leader>M` - show PROJECT diagnostics (Messages)
  * `<leader>m` - show CURRENT LINE diagnostics (Messages)
  * `<leader>o` - create line ABOVE in normal mode
  * `<leader>O` - create line BELOW in normal mode
  * `<leader>g` - Git
    * `<leader>gB` - Git show current line Blame
    * `<leader>gb` - open Git Branches
    * `<leader>gm` - open Git coMMits
    * `<leader>gs` - open Git Status
    * `<leader>gS` - Git Stage BUFFER
    * `<leader>gU` - Git reset BUFFER index
    * `<leader>gX` - Git Reset BUFFER
  * `<leader>h` - Hunk
    * `<leader>hp` - Preview Hunk
    * `<leader>hs` - Stage Hunk
    * `<leader>hu` - Unstage Hunk
    * `<leader>hx` - Reset Hunk
  * `<leader>t` - Toggling
    * `<leader>tc` - Toggle auto-Comment
    * `<leader>tf` - Toggle Formatting on save
* `g` - Go to
  * `gb` - Go to a buffer
  * `gc` - Go Comment
  * `gd` - Go to definitions
  * `gD` - Go to type Definitions
  * `gf` - Go to File
  * `gh` - GO to the LEFT window
  * `gJ` - Go to Jump point
  * `gj` - GO to the BELOW window
  * `gk` - GO to the ABOVE window
  * `gl` - GO to the RIGHT window
  * `gr` - Go to References
  * `gs` - Go to DOCUMENT Symbols
  * `gS` - Go to WORKSPACE Symbols
  * `gt` - Go to new Tab
  * `gw` - Go to Word in the CURRENT buffer
  * `gW` - Go to Word in the PROJECT
  * `gp`
    * `gph` - Go to the LEFT, Pulling the current window with you
    * `gpj` - Go DOWN, Pulling the current window with you
    * `gpk` - Go UP, Pulling the current window with you
    * `gpl` - Go to the RIFHT, Pulling the current window with you
* `]`
  * `]d` - GOTO PREVIOUS diagnostics
  * `]h` - GOTO NEXT Hunk
* `[`
  * `[d` - GOTO NEXT diagnostics
  * `[h` - GOTO PREVIOUS Hunk
* `<Tab>` - cycle buffers forward
* `<S-Tab>` - cycle buffers backward
* `<Backspace>` - close buffer
* `<Del>` - close window
* `H` - cycle tabs to the Left
* `L` - cycle tabs to the Right
* `<S-Del>` - close tab
* `<S-Up>` - move window divider UP
* `<S-Down>` - move window divider DOWN
* `<S-Left>` - move window divider LEFT
* `<S-Right>` - move window divider RIGHT
* `<Up>` - scroll UP,
* `<Down>` - scroll DOWN,
* `<Left>` - scroll horizontally to the LEFT
* `<Right>` - scroll horizontally to the RIGHT

### Visual Mode

* `<leader>`
  * `<leader>f` - Format selected range
  * `<leader>h` - Hunk
    * `<leader>hs` - Stage selected Hunks
    * `<leader>hx` - RESET selected Hunks

* `g`
  * `gc` - +Go Comment

[format_key]: https://github.com/aitvann/dotfiles/blob/master/nvim/.config/nvim/lua/dump-mappings.lua#L46
