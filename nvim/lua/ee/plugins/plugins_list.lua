
local plugins = {}

function add(name)
    local plugin = require("ee.plugins." .. name)
    table.insert(plugins, plugin)
end

add 'fugitive'
add 'rhubarb'
add 'gitsigns'
add 'sleuth'
add 'autopairs'

return plugins
