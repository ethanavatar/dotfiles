
def "fkill" [
    $process: record<
        pid: int,
        name: string>
] {
    kill $process.pid -f
    return {
        name: $process.name,
        pid: $process.pid
    }
}

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

    $processes | par-each { |$p|
        fkill $p
    }
}
