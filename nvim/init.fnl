;; [[ Vanilla Neovim Configuration ]]

;; <space> as the global leader key
(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

;; Enable relative line numbers
(set vim.wo.relativenumber true)
;; Enable line numbers
;; When relative line numbers is on, the margin will also show the current line number
(set vim.wo.number true)

;; Default tab width (Will get overridden by sleuth anyways)
(set vim.opt.expandtab true)
(set vim.opt.tabstop 4)
(set vim.opt.shiftwidth 4)

;; Enable mouse mode
(set vim.o.mouse :a)

;; Yank directly to the system clipboard
(set vim.o.clipboard :unnamedplus)

;; Wrapped lines continue with an indent
(set vim.o.breakindent true)

;; Save undo history to a file
(set vim.o.undofile true)

;; Case-insensitive searching
(set vim.o.ignorecase true)

;; Enable signcolumn
(set vim.wo.signcolumn :yes)

;; Save to swap after 250 milliseconds of inactivity for crash recovery
(set vim.o.updatetime 250)

;; Completion window options
;; `menuone`   Use the popup menu also when there is only one match.
;;	       Useful when there is additional information about the
;;	       match, e.g., what file it comes from.
;; `noselect`  Do not select a match in the menu, force the user to
;;	       select one from the menu. Only works in combination with
;;	       "menu" or "menuone".
(set vim.o.completeopt "menuone,noselect")

;; Enables 24-bit RGB color if the terminal supports it
(set vim.o.termguicolors true)

;; Make the background transparent
(fn set-bg [] (vim.cmd.highlight [:Normal :ctermbg=NONE :guibg=NONE]))
(local transparent-bg
(vim.api.nvim_create_augroup :TransparentBackground {:clear true}))
(vim.api.nvim_create_autocmd :UIEnter {:callback set-bg
                                       :group transparent-bg
                                       :pattern "*"})

;; Display a quick highlight over yanked blocks
(fn highlight-on-yank [] (vim.highlight.on_yank))
(local highlight-group
(vim.api.nvim_create_augroup :YankHighlight {:clear true}))
(vim.api.nvim_create_autocmd :TextYankPost {:callback highlight-on-yank
                                            :group highlight-group
                                            :pattern "*"})

;; Open a floating window containing the error or warning that is on the current line
(vim.api.nvim_set_keymap :n :<leader>e "<cmd>lua vim.diagnostic.open_float()<CR>" {:desc "View [E]rror"})

;; Disable netrw to use nvim-tree instead
(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)

;; [[ Install plugins ]]

;; lazy.nvim package manager
;;     https://github.com/folke/lazy.nvim
;;     `:help lazy.nvim.txt` for more info
(local lazy-path (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim))
(local lazy-installed? (vim.loop.fs_stat lazy-path))

;; Install lazy.nvim if its not installed
(when (not lazy-installed?)
  (vim.fn.system [:git :clone "--filter=blob:none" "https://github.com/folke/lazy.nvim.git" :--branch=stable lazypath]))

(vim.opt.rtp:prepend lazy-path)

(local lazy (require :lazy))
(lazy.setup [;; Git wrapper for vim
             :tpope/vim-fugitive
             ;; GitHub extension for fugitive
             :tpope/vim-rhubarb

             ;; Heuristic buffer options (Auto `shiftwidth`, `expandtab`, `tabstop`, etc)
             :tpope/vim-sleuth

             ;; File tree view
             :nvim-tree/nvim-tree.lua

             ;; A "retro" solarized dark theme
             {1 :ellisonleao/gruvbox.nvim
             :priority 1000
             :config (fn [] (vim.cmd.colorscheme :gruvbox))}

             ;; A better status bar with extensibility
             {1 :nvim-lualine/lualine.nvim
             :opts {:options {
             :component_separators "|"
             ;; Enable icons for NerdFont glyphs
             :icons_enabled true
             :section_separators ""
             :theme :gruvbox}}}

             ;; A package manager for syntax parsers and syntax highlighting
             {1 :nvim-treesitter/nvim-treesitter
             :build ":TSUpdate"
             :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]}

             ;; Language server plugins & configuration
             {1 :neovim/nvim-lspconfig :dependencies [;; A package manager for installing language servers
                                                      {1 :williamboman/mason.nvim :config true}
                                                      ;; lspconfig extension for mason
                                                      :williamboman/mason-lspconfig.nvim

                                                      ;; Show status messages for the currently running language server
                                                      ;; NOTE: `:opts {}` is the same as calling the module's `setup` function
                                                      {1 :j-hui/fidget.nvim :opts {} :tag :legacy}]}

             ;; Autocomplete plugins & configuration
             {1 :hrsh7th/nvim-cmp :dependencies [;; Snippet engine & its associated nvim-cmp source
                                                 :L3MON4D3/LuaSnip
                                                 :saadparwaiz1/cmp_luasnip

                                                 ;; nvim-cmp source for the active language server
                                                 :hrsh7th/cmp-nvim-lsp

                                                 ;; A collection of nice snippets for various languages
                                                 :rafamadriz/friendly-snippets]}

     {1 :lukas-reineke/indent-blankline.nvim
     :opts {:char "┊" :show_trailing_blankline_indent false}}

     {1 :zbirenbaum/copilot.lua
     :cmd :Copilot
     :event :InsertEnter
     :config (fn []
               (local copilot (require :copilot))
               (copilot.setup {}))} ])

;; [[ Configure Plugins ]]

;; Enable nvim-tree
(local nvim-tree (require :nvim-tree))
(nvim-tree.setup)
(vim.api.nvim_set_keymap :n :<C-n> ":NvimTreeToggle<CR>" {:desc "Toggle [N]vimTree"})

;; [[ Configure Treesitter ]]

(local ts-install (require :nvim-treesitter.install))
;; Override treesitter's default C compiler
;; I like to use zig because its lightweight and cross-platform
(tset ts-install :compilers [:zig])

;; Use git to clone parsers rather than curl
(set ts-install.prefer_git true)

(local ts-configs (require :nvim-treesitter.configs))
;; Startup options for treesitter
(ts-configs.setup {;; Make sure the parsers for these languages are installed
                   :ensure_installed [:fennel
                                      :rust
                                      :c_sharp
                                      :python]

                   ;; Allow asyncronous installation
                   :sync_install false

                   ;; Allow automatically installing a missing parser when opening a buffer
                   :auto_install true

                   ;; Enable highlighting
                   ;; For some reason not `true` by default
                   :highlight {:enable true}
                   :indent {:enable true}})

;; [[ Configure Language Servers ]]

;; This function gets run every time the language server attaches to a buffer
(fn on-attach [_ bufnr]
  ;; Helper function to bind language server actions
  (fn nmap [keys func desc]
    (when desc (set-forcibly! desc (.. "LS: " desc)))
    (vim.keymap.set :n keys func {:buffer bufnr : desc}))

  (local telescope-builtin (require :telescope.builtin))
  (fn workspace-list-folders [] (print (vim.inspect (vim.lsp.buf.list_workspace_folders))))
  (fn format [_] (vim.lsp.buf.format))

  ;; Override default vim bindings with language server enhanced alternatives
  (nmap :<leader>rn vim.lsp.buf.rename "[R]e[n]ame")
  (nmap :<leader>ca vim.lsp.buf.code_action "[C]ode [A]ction")
  (nmap :gd vim.lsp.buf.definition "[G]oto [D]efinition")
  (nmap :gI vim.lsp.buf.implementation "[G]oto [I]mplementation")
  (nmap :<leader>D vim.lsp.buf.type_definition "Type [D]efinition")
  (nmap :K vim.lsp.buf.hover "Hover Documentation")
  (nmap :<C-k> vim.lsp.buf.signature_help "Signature Documentation")
  (nmap :gD vim.lsp.buf.declaration "[G]oto [D]eclaration")
  (nmap :<leader>wa vim.lsp.buf.add_workspace_folder "[W]orkspace [A]dd Folder")
  (nmap :<leader>wr vim.lsp.buf.remove_workspace_folder "[W]orkspace [R]emove Folder")
  (nmap :<leader>wl workspace-list-folders "[W]orkspace [L]ist Folders")
  (vim.api.nvim_buf_create_user_command bufnr :Format format {:desc "Format current buffer with LSP"}))

(var capabilities (vim.lsp.protocol.make_client_capabilities))
;; Enable language server completions
(local cmp-nvim-lsp (require :cmp_nvim_lsp))
(set capabilities (cmp-nvim-lsp.default_capabilities capabilities))

;; Setup options for each language server
(local fennel-ls {:filetypes [:fnl :fennel]})
(local lua-ls {:Lua {:telemetry {:enable false}
                     :workspace {:checkThirdParty false}}})
(local omnisharp-ls {:filetypes [:cs :fs]})
(local rust-ls {:settings {:rust-analyzer {:checkOnSave {:command :clippy}}}})
(local py-ls {:filetypes [:py :python]})

;; The table of language servers to ensure are installed and their accompanying setup options
(local language-servers {:fennel_language_server fennel-ls
                         :lua_ls lua-ls
                         :omnisharp omnisharp-ls
                         :rust_analyzer rust-ls
                         :rnix {}
                         :pylsp py-ls})

(local mason-lspconfig (require :mason-lspconfig))
;; Ensure the above servers are installed
(mason-lspconfig.setup {:ensure_installed (vim.tbl_keys language-servers)})

;; A function to setup each of the language servers
(fn ls-setup-handler [server-name]
  (let [lspconfig (require :lspconfig)
        server (. lspconfig server-name)
        options (. language-servers server-name)
        file-types (. (or options {}) :filetypes)]
    (server.setup {
      :capabilities capabilities
      :filetypes file-types
      :on_attach on-attach
      :settings options})))

;; Tell lspconfig to use the above function to configure the language servers
(mason-lspconfig.setup_handlers [ls-setup-handler])

;; [[ Configure Completions ]]

(local cmp (require :cmp))
(local luasnip (require :luasnip))
;; Setup completion engine
(luasnip.config.setup {})

;; Honestly, I dont know what this does
(local luasnip-vscode-loaders (require :luasnip.loaders.from_vscode))
(luasnip-vscode-loaders.lazy_load)

;; Autotranslated from Lua because I got lazy
;; This is a mess that can most definitely be cleaned
(cmp.setup {:mapping (cmp.mapping.preset.insert {
  :<C-Space> (cmp.mapping.complete {})
  :<C-d> (cmp.mapping.scroll_docs (- 4))
  :<C-f> (cmp.mapping.scroll_docs 4)
  :<C-n> (cmp.mapping.select_next_item)
  :<C-p> (cmp.mapping.select_prev_item)
  :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace :select true})
  :<S-Tab> (cmp.mapping (fn [fallback]
                          (if (cmp.visible)
                            (cmp.select_prev_item)
                            (luasnip.locally_jumpable (- 1))
                            (luasnip.jump (- 1))
                        (fallback)))
                        [:i :s])
  :<Tab> (cmp.mapping (fn [fallback]
                        (if (cmp.visible)
                          (cmp.select_next_item)
                          (luasnip.expand_or_locally_jumpable)
                          (luasnip.expand_or_jump)
                      (fallback)))
                      [:i :s])})
  :snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
  :sources [{:name :nvim_lsp} {:name :luasnip}]})
