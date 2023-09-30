# Clears the current staged files cache and readds the provided files/directories
export def "git restage" [
    path_name: path # The file or directory to restage. (recursive for directories)
] {
    git rm -rf --cached path_name
    git add path_name
}
