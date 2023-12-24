vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.api.nvim_set_keymap(
    'n',
    '<leader>e',
    '<cmd>lua vim.diagnostic.open_float()<CR>',
    { desc = 'View [E]rror' }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>n',
    '<CMD>Oil --float<CR>',
    { desc = 'Open parent directory (Oil.nvim)' }
)
