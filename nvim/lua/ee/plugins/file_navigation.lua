local opts = {
    float = {
        padding = 6,
        win_options = {
            --winblend = 25, -- change the value here
        },
    },
}

return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = opts,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('oil').setup(opts)
    end,
}
