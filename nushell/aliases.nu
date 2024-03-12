alias cat = bat

# Default profile
$env.NVIM_APPNAME = "nvim-full"

export def "nvim full" [
    dir: path
] {
    with-env { NVIM_APPNAME = "nvim-full" } {
        nvim $dir
    }
}

export def "nvim minimal" [
    dir: path
] {
    with-env { NVIM_APPNAME = "nvim-minimal" } {
        nvim $dir
    }
}
