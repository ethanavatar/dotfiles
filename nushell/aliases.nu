alias cat = bat
alias vim = nvim

# Default profile is `nvim-full`
$env.NVIM_APPNAME = "nvim-full"

export def "nvim full" [
    dir: path
] {
    $env.NVIM_APPNAME = "nvim-full"
    nvim $dir
}

export def "nvim minimal" [
    dir: path
] {
    $env.NVIM_APPNAME = "nvim-minimal"
    nvim $dir
}
