vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap(
    "n",
    "<leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { desc = "View [E]rror" }
)

vim.api.nvim_set_keymap("n", "<C-f>", ":Format<CR>", { desc = "[F]ormat current buffer with LSP" })


