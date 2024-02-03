def "get os" [] {
    return ($nu.os-info.family + " " + $nu.os-info.kernel_version)
}

def "get distro" [] {
    return $nu.os-info.name
}


