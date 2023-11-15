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

colo onedark
