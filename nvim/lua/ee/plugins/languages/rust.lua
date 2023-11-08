return {
    'simrat39/rust-tools.nvim',
    dependencies = {
        {
            'Saecki/crates.nvim',
            tag = 'v0.4.0',
            dependencies = { 'nvim-lua/plenary.nvim' },
            opts = {},
        },
    },
    ft = 'rust',
    opts = {},
}
