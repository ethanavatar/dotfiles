return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    event = 'BufReadPre',
    config = function()
        local install = require('nvim-treesitter.install')
        install.prefer_git = true
        install.compilers = { 'zig', 'clang' }

        local configs = require('nvim-treesitter.configs')
        configs.setup({
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
