
# Remove a submodule's object references without removing the directory
export def "git submodule remove" [
    path_name: path # The directory that refers to the submodule to remove
] {
    let $git_dir = ls .git
    if $git_dir == "" {
        print "fatal: not a git repository"
        return 1
    }

    let $module = $path_name | path parse
    if $module.extension != "" {
        print "fatal: $path_name is not a directory"
        return 1
    }

    let $module_name = $module.stem

    print $"+ git config -f .gitmodules --remove-section submodule.($module_name)"
    let $result = run-external "git" "config" "-f" .gitmodules "--remove-section" $"submodule.($module_name)"

    print $"+ git config -f .git/config --remove-section submodule.($module_name)"
    let $result = run-external "git" "config" "-f" .git/config "--remove-section" $"submodule.($module_name)"

    print $"+ git add .gitmodules"
    let $result = run-external "git" "add" .gitmodules

    print $"+ git rm --cached ($path_name)"
    let $result = run-external "git" "rm" "--cached" $path_name

    print $"+ rm -rf .git/modules/$module_name"
    let $result = run-external "rm" "-rf" .git/modules/$module_name

    return 0
}
