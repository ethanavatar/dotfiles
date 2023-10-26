return {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
        local copilot = require('copilot')
        copilot.setup({
            suggestion = { auto_trigger = true },
            filetypes = {
                markdown = true,
            },
        })
    end,
}
