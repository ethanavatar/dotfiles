
# cd into every subfolder and checkout a branch that matches the given substring
export def "git subfolder checkout" [
    $branch_substring: string
    --pull
] {
    let $contents = ls -d */
    for $folder in $contents {

        if $folder.type != "dir" {
            continue
        }

        print $"+ cd ($folder.name)"
        cd $folder.name

        if $pull {
            print "+ git pull --prune origin"
            let _ = run-external "git" "pull" "--prune" "origin"
        }

        let $branch_matches = git branch -a
            | lines 
            | parse --regex "[ *]+ (.*)" 
            | insert len { |$e|
                $e | get capture0 | str length
            } | sort-by len
            | where capture0 =~ $branch_substring
            
        if $branch_matches != [] {
            let $branch_match = $branch_matches | first | get capture0
            print $"+ git checkout ($branch_match)"
            let _ = run-external "git" "checkout" $branch_match
        }

        print $"+ cd .."
        cd ..
    }
}

