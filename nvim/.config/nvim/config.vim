" mapping rules
" ' - leader
" 's - Session
" 'g - Git
" 't - Toggle
"   'tf - Toggle Formatting
"   'tc - Toggle auto Comment
" ] - go to next
"   ]d - go to next Diagnostic
"   ]h - go to next Hunk
" [ - go to previous
"   [d - go to previous Diagnostic
"   [h - go to previous Hunk
" g - Go
" gs - Go Swap
" gc - Go Comment
" <Tab> in normal - cycle buffers forward
" <S-Tab> in normal - cycle buffers backward
" <Space> in normal - inline toggle
" <Tab> in insert - inline toggle
" <Enter> - go to file


source ~/.config/nvim/modules/general.vim
source ~/.config/nvim/modules/windows.vim
source ~/.config/nvim/modules/plugin-rnvimr.vim
source ~/.config/nvim/modules/plugin-easymotion.vim
source ~/.config/nvim/modules/resize.vim
luafile ~/.config/nvim/lua/utils.lua
luafile ~/.config/nvim/lua/toggling.lua
luafile ~/.config/nvim/lua/commenting.lua
luafile ~/.config/nvim/lua/colorscheme.lua
luafile ~/.config/nvim/lua/tabs.lua
luafile ~/.config/nvim/lua/git.lua
luafile ~/.config/nvim/lua/start-screen.lua
luafile ~/.config/nvim/lua/session.lua
luafile ~/.config/nvim/lua/auto-pairs.lua
luafile ~/.config/nvim/lua/buffers.lua
luafile ~/.config/nvim/lua/status-line/init.lua
luafile ~/.config/nvim/lua/modules/plugin-nvim-cmp.lua
luafile ~/.config/nvim/lua/modules/plugin-nvim-colorizer.lua
luafile ~/.config/nvim/lua/modules/plugin-neoscroll.lua
luafile ~/.config/nvim/lua/modules/plugin-telescope.lua
luafile ~/.config/nvim/lua/modules/plugin-telescope-emoji.lua
luafile ~/.config/nvim/lua/modules/plugin-treesitter.lua
luafile ~/.config/nvim/lua/modules/plugin-renamer.lua
luafile ~/.config/nvim/lua/modules/lsp/init.lua

