local lazy_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazy_path,
    }
end

local home = os.getenv("HOMEPATH")
local cache_dir = home .. "/.cache/nvim/"

vim.opt.rtp:prepend(cache_dir)
vim.opt.rtp:prepend(lazy_path)

local disabled_plugins = require("ee.plugins.disabled_plugins")

local plugins_spec = require("ee.plugins.plugins_list")

local lazy = require("lazy")
lazy.setup(plugins_spec, {
    defaults = { lazy = true },
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    install = {
        missing = true,
        colorscheme = "gruvbox",
    },
    checker = { enabled = false, notify = false },
    change_detection = { enabled = false, notify = false },
    performance = {
        cache = {
            enabled = true,
            path = cache_dir .. "/lazy/cache",
            disable_events = { "VimEnter", "BufReadPre" },
        },
        rtp = {
            reset = true,
            disabled_plugins = disabled_plugins,
        }
    }
})

