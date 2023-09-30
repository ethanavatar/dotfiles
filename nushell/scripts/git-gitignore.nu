use '~/.config/nushell/scripts/open-ignore.nu' 'open ignore'

export def "git gitignore" [
	template_name: string
] {
    let $endpoint = $'https://raw.githubusercontent.com/github/gitignore/main/($template_name).gitignore'

    let $contents = http get $endpoint

    if ($contents | is-empty) {
        print $"Couldn't find template by the name of `($template_name)`"
        return
    }

    let $path = $'(pwd)/.gitignore'

    $contents | save $path
    print $'Gitignore template `($template_name)` has been written to `($path)`'
    return (open ignore $path) 
}
