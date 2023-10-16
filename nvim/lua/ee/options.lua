vim.opt.shell = 'nu'

vim.o.termguicolors = true

vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.diagnostic.config({
    float = {
        'border',
        'rounded',
        focusable = true,
        header = false,
    },
    virtual_text = false,
})

vim.o.mouse = 'a'
-- vim.o.clipboard = unnamedplus
vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.completeopt = 'menuone,noselect'

vim.diagnostic.config({
    virtual_text = true,
})
