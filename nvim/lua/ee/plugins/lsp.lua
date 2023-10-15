local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        { 'williamboman/mason.nvim',           opts = {} },
        { 'williamboman/mason-lspconfig.nvim', opts = {} },
        { 'j-hui/fidget.nvim',                 tag = 'legacy', opts = {} },
        { "folke/neodev.nvim",                 opts = {} },
    },
    config = function()
        local lspconfig = require 'lspconfig'
        local mason_lspconfig = require 'mason-lspconfig'
        mason_lspconfig.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }
            end,
        }
    end
}
