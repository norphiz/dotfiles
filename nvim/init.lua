vim.o.ls = 0
vim.o.sw = 4

vim.o.nu = true
vim.o.et = true
vim.o.ic = true
vim.o.scs = true
vim.o.rnu = true

vim.o.ru = false
vim.o.sc = false
vim.o.swf = false
vim.o.smd = false
vim.o.hls = false
vim.o.wrap = false

vim.o.sdf = "NONE"
vim.o.fcs = "eob: "
vim.o.cb = "unnamedplus"

vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_dirhistmax = 0

vim.keymap.set("n", ";", ":", {})
vim.keymap.set("n", "<Leader>c", ":q<CR>", { silent = true })
vim.keymap.set("n", "<Leader>s", ":so<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":qa!<CR>", { silent = true })
vim.keymap.set("n", "<Leader>e", ":Lex<CR>", { silent = true })
vim.keymap.set("n", "<Leader>t", ":tabe<CR>", { silent = true })
vim.keymap.set("n", "<Leader>w", ":sil :w<CR>", { silent = true })
vim.keymap.set("n", "<Leader>h", ":winc h<CR>", { silent = true })
vim.keymap.set("n", "<Leader>j", ":winc j<CR>", { silent = true })
vim.keymap.set("n", "<Leader>k", ":winc k<CR>", { silent = true })
vim.keymap.set("n", "<Leader>l", ":winc l<CR>", { silent = true })
vim.keymap.set("n", "<Leader><Up>", ":winc k<CR>", { silent = true })
vim.keymap.set("n", "<Leader><Left>", ":winc h<CR>", { silent = true })
vim.keymap.set("n", "<Leader><Down>", ":winc j<CR>", { silent = true })
vim.keymap.set("n", "<Leader><Right>", ":winc l<CR>", { silent = true })

if os.getenv("TERM") ~= "linux" then
    vim.o.tgc = true
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", command = "se fo-=ro"
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    command = "ec ''"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    command = "sil winc T"
})

if os.execute("test -d ~/.config/nvim/pack") then
    vim.cmd.colo("nord")
    require("nvim-autopairs").setup()
end
