local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        lazy_path,
    })
    vim.fn.system({
        'git',
        '-C',
        lazy_path,
        'checkout',
        'tags/stable',
    })
end

-- Windows ENV var
local home = os.getenv('HOMEPATH')
if home == nil then
    -- Anything but Windows
    home = os.getenv('HOME')
end
local cache_dir = home .. '/.cache/nvim'
-- create cache dir if it doesn't exist
if not vim.loop.fs_stat(cache_dir) then
    vim.loop.fs_mkdir(cache_dir, 493, function()
        -- 493 is decimal for 0755
    end)
end

vim.opt.rtp:prepend(cache_dir)
vim.opt.rtp:prepend(lazy_path)

local plugins_spec = require('ee.plugins.plugins_list')
local disabled_plugins = require('ee.plugins.disabled_plugins')

require('lazy').setup({
    spec = plugins_spec,
    defaults = { lazy = true },
    lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json',
    install = {
        missing = true,
        colorscheme = { 'gruvbox' },
    },
    checker = { enabled = false, notify = false },
    change_detection = { enabled = false, notify = false },
    diff = {
        cmd = 'git',
    },
    performance = {
        cache = {
            enabled = true,
            path = cache_dir .. '/lazy/cache',
            disable_events = { 'VimEnter', 'BufReadPre' },
        },
        rtp = {
            reset = true,
            disabled_plugins = disabled_plugins,
        },
    },
})
