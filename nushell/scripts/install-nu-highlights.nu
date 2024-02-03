def is_windows [] { $nu.os-info.name == "windows" }

mut $home = ""
if (is_windows) {
    $home = $env.HOMEPATH
} else {
    $home = $env.HOME
}

let remote = "https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/nu/"
let local = (
    $env.XDG_DATA_HOME?
    | default ($home | path join ".local" "share")
    | path join "nvim" "lazy" "nvim-treesitter" "queries" "nu"
)

let file = "highlights.scm"

mkdir $local
http get ([$remote $file] | str join "/") | save --force ($local | path join $file)
