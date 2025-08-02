vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.termguicolors = true
vim.o.colorcolumn = '80'
vim.o.signcolumn = 'yes'

vim.o.ignorecase = true
vim.o.swapfile = false

vim.o.mouse = ''

vim.g.zig_fmt_autosave = 0

vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
        vim.api.nvim_set_hl(0, 'Normal', { background = nil })
        vim.api.nvim_set_hl(0, 'PMenu', { background = nil })
        vim.api.nvim_set_hl(0, 'SignColumn', { background = nil })
    end,
    group = vim.api.nvim_create_augroup('TransparentBackground', {}),
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
})

vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.icons', version = 'v0.16.0' },
    { src = 'https://github.com/stevearc/oil.nvim', version = 'v2.15.0' },

    -- TODO: Typst Language Server
    -- Maybe also ftplugin stuff
    {
        src = 'https://github.com/chomosuke/typst-preview.nvim',
        version = 'v1.3.2',
    },
})

require('mini.icons').setup()
require('oil').setup({
    view_options = { show_hidden = true },
    float = { padding = 6, win_options = { winblend = 12 } },
})

vim.keymap.set(
    'n',
    '<leader>n',
    '<CMD>Oil --float<CR>',
    { desc = 'Open parent directory (Oil.nvim)' }
)

require('typst-preview').setup()
