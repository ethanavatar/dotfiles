
# kill all processes of the executable name
export def "killall" [
    $exe_name: string
    --wildcard
] {
    mut $processes = (ps | where name == $exe_name) 

    if $wildcard {
        $processes = (ps | where name =~ $exe_name)
    }

    if $processes == [] {
        print $"No processes found for: ($exe_name)"
        return
    }

    for $process in $processes {
        print $"Killing process: ($process.pid) - ($process.name)"
        kill $process.pid -f
    }
}
