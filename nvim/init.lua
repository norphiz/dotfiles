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

vim.g.netrw_banner = 0
vim.g.netrw_dirhistmax = 0

vim.api.nvim_set_keymap("n", ";", ":", {})
vim.api.nvim_set_keymap("n", "<C-s>", ":x<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-q>", ":q!<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-t>", ":tabnew<CR>", { silent = true })

if os.getenv("TERM") ~= "linux" then
    vim.o.tgc = true
    require("colorizer").setup()
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", callback = function()
        vim.opt.fo:remove { "c", "r", "o" }
    end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.txt", callback = function()
        vim.cmd.winc("L")
    end
})

vim.cmd.colo("nord")
require("nvim-autopairs").setup()
