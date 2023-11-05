return {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
    event = 'VimEnter',
    priority = 1000,
    config = function()
        vim.cmd.colorscheme('gruvbox')
    end,
}
