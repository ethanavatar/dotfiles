local transparent_background = vim.api.nvim_create_augroup('TransparentBackground', {})
vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
        vim.cmd.highlight({ "Normal", "ctermbg=NONE", "guibg=NONE" })
        vim.cmd.highlight({ "Pmenu", "ctermbg=NONE", "guibg=NONE" })
    end,
    group = highlight_group,
    pattern = '*',
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})


