export def "open ignore" [
    path_name: path
] {
    return (open $path_name | lines | parse '{Pattern}' | where Pattern =~ "^[^#].*$")
}

