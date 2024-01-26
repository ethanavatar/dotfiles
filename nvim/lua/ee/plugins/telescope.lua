local function is_windows()
    return package.config:sub(1, 1) == '\\'
end

local fzf_build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && '
    .. 'cmake --build build --config Release && '
    .. 'cmake --install build --prefix build'

if not is_windows() then
    fzf_build = 'make'
end

local function fzf_build_cond()
    if is_windows() then
        return vim.fn.executable('cmake') == 1
    end

    return vim.fn.executable('make') == 1
end

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = fzf_build,
            cond = fzf_build_cond,
        },
    },
}