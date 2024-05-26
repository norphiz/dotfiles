vim.o.ls = 0
vim.o.sw = 4

vim.o.ru = false
vim.o.swf = false
vim.o.smd = false
vim.o.wrap = false

vim.o.nu = true
vim.o.et = true
vim.g.ic = true
vim.o.sc = true
vim.o.scs = true

vim.o.sdf = "NONE"
vim.o.fcs = "eob: "
vim.o.cb = "unnamedplus"

vim.cmd.colo "dracula"

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.fo:remove {"c", "r", "o"}
    end
})

if os.getenv "TERM" ~= "linux" then
    vim.o.tgc = true
end

if os.execute "test -d $HOME/.config/nvim/pack/plugins/start/nvim-autopairs" then
    require "nvim-autopairs".setup()
end

if os.execute "test -d $HOME/.config/nvim/pack/plugins/start/nvim-treesitter" then
    require "nvim-treesitter.configs".setup {
        highlight = {
            enable = true
        }
    }
end
