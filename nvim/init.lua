vim.o.ls = 0
vim.o.sw = 4

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
vim.keymap.set("n", "<Leader>s", ":x<CR>", { silent = true })
vim.keymap.set("n", "<Leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":q!<CR>", { silent = true })
vim.keymap.set("n", "<Leader>t", ":tabe<CR>", { silent = true })
vim.keymap.set("n", "<Leader>e", ":Lexplore<CR>", { silent = true })

if os.getenv("TERM") ~= "linux" then
    vim.o.tgc = true
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", callback = function()
        vim.opt.fo:remove({ "r", "o" })
    end
})

if os.execute("test -d ~/.config/nvim/pack") then
    vim.cmd.colo("nord")
    require("nvim-autopairs").setup()
end
