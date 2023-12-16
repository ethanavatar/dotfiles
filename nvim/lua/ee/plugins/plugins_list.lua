local plugins = {}

local function add(name)
    local plugin = require('ee.plugins.' .. name)
    table.insert(plugins, plugin)
end

add('theme')

add('gitstuff')
add('sleuth')
add('autopairs')
add('treeview')
add('lualine')
add('indent-blankline')
add('whichkey')
--add('harpoon')

add('treesitter')

add('languages.rust')
add('languages.java')

add('lsp')
add('cmp')
add('copilot')

return plugins
