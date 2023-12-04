local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>f', vim.lsp.buf.format, '[F]ormat Buffer')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>s', vim.lsp.buf.signature_help, 'Signature Documentation')
end

local servers = {}

return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'williamboman/mason.nvim', opts = {} },
        { 'williamboman/mason-lspconfig.nvim', opts = {} },
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
        {
            'zeioth/garbage-day.nvim',
            excluded_lsp_clients = { 'copilot' },
            opts = {},
        },
        { 'folke/neodev.nvim', ft = 'lua', opts = {} },
        { 'hrsh7th/cmp-nvim-lsp', opts = {} },
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x', opts = {} },
    },
    config = function()
        local lsp = require('lsp-zero')
        lsp.configure('gdscript', {
            force_setup = true, -- because the LSP is global. Read more on lsp-zero docs about this.
            single_file_support = false,
            cmd = { 'ncat', '127.0.0.1', '6008' }, -- the important trick for Windows!
            root_dir = require('lspconfig.util').root_pattern(
                'project.godot',
                '.git'
            ),
            filetypes = { 'gd', 'gdscript', 'gdscript3' },
        })

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
