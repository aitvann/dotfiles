if (has('termguicolors'))
    set termguicolors
endif

" tokyonight
let g:tokyonight_style = 'storm'
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 1

" nord
let g:nord_italic = 1
let g:nord_italic_comments = 1

" gruvbox
let g:gruvbox_contrast_dark = 'medium'

colorscheme tokyonight

if (g:colors_name == 'tokyonight')
    let s:bg4_storm = '#3a405e'
    let g:terminal_color_0 = s:bg4_storm
    let g:terminal_color_8 = s:bg4_storm
endif

