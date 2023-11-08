local on_attach = function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.buf.inlay_hint(bufnr, true)
    end

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

local servers = {}

return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
        { 'williamboman/mason.nvim', opts = {} },
        { 'williamboman/mason-lspconfig.nvim', opts = {} },
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
        { 'zeioth/garbage-day.nvim', event = 'VeryLazy', opts = {} },
        { 'folke/neodev.nvim', ft = 'lua', opts = {} },
    },
    config = function()
        local lspconfig = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup_handlers({
            function(server_name)
                local capabilities = vim.lsp.protocol.make_client_capabilities()

                local server_settings = servers[server_name] or {}
                local file_types = (server_settings or {}).filetypes

                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = server_settings,
                    filetypes = file_types,
                })
            end,
        })
    end,
}
