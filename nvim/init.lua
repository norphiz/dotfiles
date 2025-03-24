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
vim.g.netrw_winsize = 20
vim.g.netrw_dirhistmax = 0

vim.api.nvim_set_keymap("n", ";", ":", {})
vim.api.nvim_set_keymap("n", "<A-s>", ":x<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-q>", ":q!<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-t>", ":tabe<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-e>", ":Lexplore<CR>", { silent = true })

if os.getenv("TERM") ~= "linux" then
    vim.o.tgc = true
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", callback = function()
        vim.opt.fo:remove({ "r", "o" })
    end
})

vim.cmd.colo("nord")
require("nvim-autopairs").setup()
