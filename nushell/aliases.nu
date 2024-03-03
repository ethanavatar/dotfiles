alias cat = bat
alias vim = nvim
export def "nvim minimal" [
    dir: path
] {
    $env.NVIM_APPNAME = "nvim-minimal"
    nvim $dir
}
