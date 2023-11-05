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

add('treesitter')

add('lsp')
add('cmp')
add('copilot')

return plugins
