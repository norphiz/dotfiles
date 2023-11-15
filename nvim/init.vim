set nowrap
set number
set noruler
set noshowcmd
set expandtab
set smartcase
set tabstop=4
set nohlsearch
set noshowmode
set noswapfile
set ignorecase
set shiftwidth=4
set laststatus=0
set shadafile=NONE
set clipboard+=unnamedplus
autocmd FileType * set formatoptions-=cro

if $TERM != "linux"
    set termguicolors
end

let g:onedark_color_overrides = {
\ "red": { "gui": "#ff6e7a", "cterm": "204", "cterm16": "1" },
\ "dark_red": { "gui": "#BE5046", "cterm": "196", "cterm16": "9" },
\ "green": { "gui": "#c0fa96", "cterm": "114", "cterm16": "2" },
\ "yellow": { "gui": "#ffd587", "cterm": "180", "cterm16": "3" },
\ "dark_yellow": { "gui": "#D19A66", "cterm": "173", "cterm16": "11" },
\ "blue": { "gui": "#6ebeff", "cterm": "39", "cterm16": "4" },
\ "purple": { "gui": "#e387ff", "cterm": "170", "cterm16": "5" },
\ "cyan": { "gui": "#66deed", "cterm": "38", "cterm16": "6" },
\ "white": { "gui": "#dfe5f2", "cterm": "145", "cterm16": "7" },
\ "black": { "gui": "#21242b", "cterm": "235", "cterm16": "0" },
\ "foreground": { "gui": "#dfe5f2", "cterm": "145", "cterm16": "7" },
\ "background": { "gui": "#21242b", "cterm": "235", "cterm16": "0" },
\ "comment_grey": { "gui": "#5C6370", "cterm": "59", "cterm16": "15" },
\ "gutter_fg_grey": { "gui": "#4B5263", "cterm": "238", "cterm16": "15" },
\ "cursor_grey": { "gui": "#2C323C", "cterm": "236", "cterm16": "8" },
\ "visual_grey": { "gui": "#3E4452", "cterm": "237", "cterm16": "15" },
\ "menu_grey": { "gui": "#3E4452", "cterm": "237", "cterm16": "8" },
\ "special_grey": { "gui": "#3B4048", "cterm": "238", "cterm16": "15" },
\ "vertsplit": { "gui": "#181A1F", "cterm": "59", "cterm16": "15" },
\}

colo onedark
