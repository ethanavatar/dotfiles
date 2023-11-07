local function background_transparent()
    vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
    vim.cmd('highlight Pmenu ctermbg=NONE guibg=NONE')
    vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')
end

local function background_opaque()
    vim.cmd('highlight Normal ctermbg=NONE guibg=#282828')
    vim.cmd('highlight Pmenu ctermbg=NONE guibg=#282828')
    vim.cmd('highlight SignColumn ctermbg=NONE guibg=#282828')
end

local function toggle_background(mode)
    if mode == 'transparent' then
        background_transparent()
    elseif mode == 'opaque' then
        background_opaque()
    else
        print('Invalid argument: ' .. mode)
    end
end

local transparent_background =
    vim.api.nvim_create_augroup('TransparentBackground', {})
vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
        background_transparent()
    end,
    group = transparent_background,
})

vim.api.nvim_create_user_command('Background', function(opts)
    toggle_background(opts.args)
end, {
    nargs = 1,
    complete = function(_, _, _)
        return { 'transparent', 'opaque' }
    end,
})

local highlight_group =
    vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
