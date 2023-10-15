return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    config = function()
        local nvim_tree = require("nvim-tree")
        nvim_tree.setup({})

        vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle [N]vimTree" })
    end,
}
