vim.o.wrap=0
vim.o.ruler=0
vim.o.number=1
vim.o.tabstop=4
vim.o.showcmd=0
vim.o.showmode=0
vim.o.swapfile=0
vim.o.expandtab=1
vim.o.smartcase=1
vim.o.laststatus=0
vim.o.ignorecase=1
vim.o.cursorline=1
vim.o.shiftwidth=4
vim.o.shadafile="NONE"
vim.o.clipboard="unnamedplus"

require "hl"

vim.api.nvim_create_autocmd("FileType", {pattern="*", callback=function()vim.opt.formatoptions:remove{"c","r","o"}end})
