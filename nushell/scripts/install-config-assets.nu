
export def "install config assets" [] {
    let $home = if ($nu.os-info.name == "windows") {
        $env.HOMEPATH
    } else {
        $env.HOME
    }
    let $xdg_home = $env.XDG_CONFIG_HOME
    let $asset_map = [
        [source destination];
        [$"($xdg_home)/.xprofile" $home]
    ]

    for $asset in $asset_map {
        let $source = $asset | get source
        let $destination = $asset | get destination

        if ($destination | path dirname | path exists) {
            print $"+ cp ($source) ($destination)"
            cp $source $destination
        } else {
            print $"- Skipping ($destination). Part of the path does not exist."
        } 
    }
}
