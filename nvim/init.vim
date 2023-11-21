se nu
se et
se ic
se scs
se ls=0
se ts=4
se sw=4
se noru
se nosc
se nohls
se nosmd
se noswf
se nowrap
se cb+=unnamedplus

autocmd FileType * se fo-=cro

let g:onedark_color_overrides = {
\ "blue": { "gui": "#6ebeff", "cterm": "39", "cterm16": "4" },
\ "cyan": { "gui": "#66deed", "cterm": "38", "cterm16": "6" },
\ "red": { "gui": "#ff6e7a", "cterm": "204", "cterm16": "1" },
\ "black": { "gui": "#21242b", "cterm": "235", "cterm16": "0" },
\ "green": { "gui": "#c0fa96", "cterm": "114", "cterm16": "2" },
\ "white": { "gui": "#dfe5f2", "cterm": "145", "cterm16": "7" },
\ "purple": { "gui": "#e387ff", "cterm": "170", "cterm16": "5" },
\ "yellow": { "gui": "#ffd587", "cterm": "180", "cterm16": "3" },
\ "dark_red": { "gui": "#be5046", "cterm": "196", "cterm16": "9" },
\ "vertsplit": { "gui": "#181a1f", "cterm": "59", "cterm16": "15" },
\ "menu_grey": { "gui": "#3e4452", "cterm": "237", "cterm16": "8" },
\ "background": { "gui": "#21242b", "cterm": "235", "cterm16": "0" },
\ "foreground": { "gui": "#dfe5f2", "cterm": "145", "cterm16": "7" },
\ "cursor_grey": { "gui": "#2c323c", "cterm": "236", "cterm16": "8" },
\ "comment_grey": { "gui": "#5c6370", "cterm": "59", "cterm16": "15" },
\ "dark_yellow": { "gui": "#d19a66", "cterm": "173", "cterm16": "11" },
\ "visual_grey": { "gui": "#3e4452", "cterm": "237", "cterm16": "15" },
\ "special_grey": { "gui": "#3b4048", "cterm": "238", "cterm16": "15" },
\ "gutter_fg_grey": { "gui": "#4b5263", "cterm": "238", "cterm16": "15" }
\}

let g:onedark_hide_endofbuffer = 1

if $TERM != "linux"
    se tgc
en

colo onedark 
