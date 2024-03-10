alias cat = bat
export def "nvim minimal" [
    dir: path
] {
    $env.NVIM_APPNAME = "nvim-minimal"
    nvim $dir
}
