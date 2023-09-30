use '~/.config/nushell/scripts/open-ignore.nu' 'open ignore'

# Add or remove (-r) a pattern from the current directory's .gitignore
export def "git ignore" [
    --remove (-r) # If enabled, remove the given pattern from the list of ignored patterns
    pattern?: string # The pattern to ignore
] {
    let $path = $'(pwd)/.gitignore'
    let $exists = $path | path exists

    if ($pattern == null) {
        if not $exists {
            print 'Couldnt find a .gitignore file in the current directory'
            return
        }

        return (open ignore $path) 
    }

    if $remove {
        open .gitignore
            | lines
            | where $it != $pattern
            | to text
            | into string
            | save $path --force
        print $'Removed `($pattern)` from `($path)`'
        return (open ignore $path) 
    }

    if not $exists {
        $pattern | save $path
        print $'Created a new gitignore at `($path)`'
        return (open ignore $path) 
    }

    mut $content = (char newline) + $pattern

    if (open $path | is-empty) {
        $content = $pattern
    }

    $content | save $path --append
    print $'Added `($pattern)` to `($path)`'
    return (open ignore $path) 
}

