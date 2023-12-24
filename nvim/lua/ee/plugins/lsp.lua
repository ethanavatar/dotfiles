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

    --nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    --nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>s', vim.lsp.buf.signature_help, 'Signature Documentation')

    local telescope = require('telescope.builtin')

    nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
    nmap('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap(
        '<leader>ws',
        telescope.lsp_dynamic_workspace_symbols,
        '[W]orkspace [S]ymbols'
    )
end

return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'williamboman/mason.nvim', opts = {} },
        { 'williamboman/mason-lspconfig.nvim', opts = {} },
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
        { 'folke/neodev.nvim', ft = 'lua', opts = {} },
        { 'hrsh7th/cmp-nvim-lsp', opts = {} },
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x', opts = {} },
    },
    config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.configure('gdscript', {
            force_setup = true, -- because the LSP is global. Read more on lsp-zero docs about this.
            single_file_support = false,
            cmd = { 'ncat', '127.0.0.1', '6008' }, -- the important trick for Windows!
            root_dir = require('lspconfig.util').root_pattern(
                'project.godot',
                '.git'
            ),
            filetypes = { 'gd', 'gdscript', 'gdscript3' },
        })

        lsp_zero.on_attach(on_attach)

        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup({
            handlers = {
                lsp_zero.default_setup,
                jdtls = function() end,
            },
        })
    end,
}
