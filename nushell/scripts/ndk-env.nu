export def "ndk-env" [
    $ndk_home: path
] {
    $env.NDK_HOME = $ndk_home
    return ($env.Path
        | split row (char esep) 
        | prepend $env.NDK_HOME
        | uniq)
}
