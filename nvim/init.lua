vim.o.ls = 0
vim.o.sw = 4

vim.o.nu = true
vim.o.et = true
vim.o.ic = true
vim.o.scs = true

vim.o.ru = false
vim.o.sc = false
vim.o.swf = false
vim.o.smd = false
vim.o.hls = false
vim.o.wrap = false

vim.o.sdf = "NONE"
vim.o.fcs = "eob: "
vim.o.cb = "unnamedplus"

vim.api.nvim_set_keymap("n", ";", ":", {})
vim.api.nvim_set_keymap("n", "<C-s>", ":x<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-q>", ":q!<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-t>", ":tabnew<CR>", { silent = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.txt", callback = function()
        vim.cmd.winc("L")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", callback = function()
        vim.opt.fo:remove { "c", "r", "o" }
    end
})

if os.getenv("TERM") ~= "linux" then
    vim.o.tgc = true
end

if os.execute("test -d ~/.config/nvim/pack/plugins/start/vim") == 0 then
    vim.cmd.colo("nord")
end

if os.execute("test -d ~/.config/nvim/pack/plugins/start/nvim-autopairs") == 0 then
    require("nvim-autopairs").setup()
end 
