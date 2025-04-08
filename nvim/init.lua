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
vim.g.netrw_cursor = 0
vim.g.netrw_winsize = 20
vim.g.netrw_dirhistmax = 0

vim.keymap.set("n", ";", ":", {})
vim.keymap.set("n", "<M-q>", ":qa!<CR>", { silent = true })
vim.keymap.set("n", "<M-e>", ":Lex<CR>", { silent = true })
vim.keymap.set("n", "<M-t>", ":tabe<CR>", { silent = true })
vim.keymap.set("n", "<M-Up>", ":winc k<CR>", { silent = true })
vim.keymap.set("n", "<M-Left>", ":winc h<CR>", { silent = true })
vim.keymap.set("n", "<M-Down>", ":winc j<CR>", { silent = true })
vim.keymap.set("n", "<M-Right>", ":winc l<CR>", { silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
    command = "se fo-=ro"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    callback = function()
        vim.cmd("sil winc T")
        print("")
    end
})

if os.execute("test -d .config/nvim/pack") then
    vim.cmd.colo("nord")
    require("nvim-autopairs").setup()
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3b4252" })
end
