def "git gitignore" [template_name: string] {
    let $endpoint = $'https://raw.githubusercontent.com/github/gitignore/main/($template_name).gitignore'

    let $contents = curl $endpoint

    if $contents | is-empty {
        print $'Couldn't find template by the name of `($template_name)`'
        return
    }

    $contents | save $'(pwd)/.gitignore'
    print $'Gitignore template `($template_name)` has been written to (pwd)/.gitignore'
}
