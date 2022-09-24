-- mapping rules
-- ' - leader
-- 's - Session
-- 'g - Git
-- 't - Toggle
--   'tf - Toggle Formatting
--   'tc - Toggle auto Comment
-- ] - go to next
--   ]d - go to next Diagnostic
--   ]h - go to next Hunk
-- [ - go to previous
--   [d - go to previous Diagnostic
--   [h - go to previous Hunk
-- g - Go
-- gs - Go Swap
-- gc - Go Comment
-- <Tab> in normal - cycle buffers forward
-- <S-Tab> in normal - cycle buffers backward
-- <Space> in normal - inline toggle
-- <Tab> in insert - inline toggle
-- <Enter> - go to file

vim.cmd 'source ~/.config/nvim/lua/plugins.vim'
require 'utils'
require 'general'
require 'lsp'
require 'plugin-treesitter'
require 'plugin-telescope'
require 'completion'
require 'git'
require 'file-explorer'
require 'commenting'
vim.cmd 'source ~/.config/nvim/lua/resize.vim'
require 'auto-pairs'
require 'quick-jump'
require 'status-line'
require 'start-screen'
require 'session'
require 'toggling'
require 'plugin-neoscroll'
require 'colorscheme'
require 'plugin-whichkey'
require 'plugin-nvim-colorizer'
require 'dump-mappings'
require 'plugin-code-action-menu'
