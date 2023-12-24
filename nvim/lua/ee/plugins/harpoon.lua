return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'VeryLazy',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local harpoon = require('harpoon')
        harpoon.setup()
        vim.keymap.set('n', '<leader>a', function()
            harpoon:list():append()
        end)
        vim.keymap.set('n', '<C-e>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        for i = 1, 9 do
            vim.keymap.set('n', '<A-' .. i .. '>', function()
                harpoon:list():select(i)
            end)
        end

        vim.keymap.set('n', '<A-h>', function()
            harpoon:list():prev()
        end)
        vim.keymap.set('n', '<A-l>', function()
            harpoon:list():next()
        end)
    end,
}
