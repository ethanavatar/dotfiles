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
    '<leader>d',
    '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    { desc = 'View Symbol [D]ocumentation' }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>n',
    ':NvimTreeToggle<CR>',
    { desc = 'Toggle [N]vimTree' }
)
