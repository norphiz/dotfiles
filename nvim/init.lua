vim.o.ls = 0
vim.o.sw = 4
vim.o.nu = true
vim.o.et = true
vim.g.ic = true
vim.o.sc = true
vim.o.ru = false
vim.o.scs = true
vim.o.swf = false
vim.o.smd = false
vim.o.sdf = "NONE"
vim.o.wrap = false
vim.o.fcs = "eob: "
vim.o.cb = "unnamedplus"

vim.cmd.colo "dracula"

vim.api.nvim_set_keymap("n", ";", ":", {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.fo:remove {"c", "r", "o"}
    end
})

if os.getenv "TERM" ~= "linux" then
    vim.o.tgc = true
end

if os.execute "test -d $HOME/.config/nvim/pack/plugins/start/nvim-autopairs" == 0 then
    require "nvim-autopairs".setup()
end

if os.execute "test -d $HOME/.config/nvim/pack/plugins/start/nvim-treesitter" == 0 then
    require "nvim-treesitter.configs".setup {
        highlight = {
            enable = true
        }
    }
end
