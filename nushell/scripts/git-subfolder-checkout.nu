
# cd into every subfolder and checkout a branch that matches the given substring
export def "git subfolder checkout" [
    $branch_substring: string
] {
    let $contents = ls -d */
    for $folder in $contents {

        if $folder.type != "dir" {
            continue
        }

        print $"+ cd ($folder.name)"
        cd $folder.name

        let $branch_matches = git branch -a
            | lines 
            | parse --regex "[ *]+ (.*)" 
            | where capture0 =~ $branch_substring
            
        if $branch_matches != [] {
            let $branch_match = $branch_matches | first
            print $"+ git checkout ($branch_match)"
            let _ = run-external "git" "checkout" $'"($branch_match)\*"'
        }

        print $"+ cd .."
        cd ..
    }
}

