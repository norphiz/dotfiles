vim.o.ls = 0
vim.o.nu = 1
vim.o.et = 1
vim.g.ic = 1
vim.o.sw = 4
vim.o.ru = 0
vim.o.sc = 0
vim.o.scs = 1
vim.o.smd = 0
vim.o.swf = 0
vim.o.wrap = 0
vim.o.sdf = "NONE"
vim.o.cb = "unnamedplus"

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.fo:remove {"c", "r", "o"}
    end
})

if os.getenv "TERM" ~= "linux" then
    vim.o.tgc = 1
end

vim.cmd.colo "dracula"

require "colorizer".setup()

require "nvim-autopairs".setup()

require "nvim-treesitter.configs".setup {
    vim.opt.rtp:append "~/.local/share/nvim/treesitter",
    parser_install_dir = "~/.local/share/nvim/treesitter",
    highlight = {
        enable = 1
    }
}
