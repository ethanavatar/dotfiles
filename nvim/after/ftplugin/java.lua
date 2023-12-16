local lsp_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls/'

local _, jdtls = pcall(require, 'jdtls')
if _ == nil then
    vim.notify('nvim-jdtls not found!', vim.log.levels.WARN)
    return
end

local jdtls_setup = require('jdtls.setup')
local project_root = jdtls_setup.find_root({ '.git', 'mvnw', 'gradlew' })

local exec = lsp_dir .. 'bin/jdtls.bat'
if not vim.fn.has('win32') then
    exec = lsp_dir .. 'bin/jdtls'
end

local config = {
    cmd = { exec },
    root_dir = project_root,
}

jdtls.start_or_attach(config)
