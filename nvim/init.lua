vim.o.ls = 0
vim.o.sw = 4
vim.o.nu = true
vim.o.et = true
vim.g.ic = true
vim.o.sc = true
vim.o.ru = false
vim.o.scs = true
vim.o.swf = true
vim.o.smd = false
vim.o.sdf = "NONE"
vim.o.wrap = false
vim.o.cb = "unnamedplus"

vim.cmd.colo "dracula"

if os.getenv "TERM" ~= "linux" then
    vim.o.tgc = true
end

vim.api.nvim_set_hl(0, "EndOfBuffer", {fg = "#282a36", ctermfg = "black"})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.fo:remove {"c", "r", "o"}
    end
})

require "colorizer".setup()

require "nvim-autopairs".setup()

require "nvim-treesitter.configs".setup {
    vim.opt.rtp:append "~/.local/share/nvim/treesitter",
    parser_install_dir = "~/.local/share/nvim/treesitter",
    highlight = {
        enable = true
    }
}
