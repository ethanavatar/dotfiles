def "git unskip" [
    $files: list<string>
] {
    $files | each { |$f|
        git update-index --no-skip-worktree $f
    }
}

def "git skip" [
    $files: list<string>
] {
    $files | each { |$f|
        print $"Skipping ($f)"
        git restore --staged $f
        git update-index --skip-worktree $f
    }
}

export def "git skip-staged" [] {
    let $files = (git status | lines | str trim | parse "modified:   {filepath}" | get filepath)
    git skip $files
}

export def "git listsw" [] {
    let $files = (git ls-files -v . | lines | parse "{modifier} {filepath}" | where modifier == "S")
    return ($files | get filepath) 
}

export def "git checkoutsw" [
    $branch: string
] {
    let $files = git listsw
    git unskip $files
    git stash
    git checkout $branch
    git stash pop
    git skip $files
}
