def is_windows [] { $nu.os-info.name == "windows" }

let $path_conversion = {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
}

if (is_windows) {
    $env.ENV_CONVERSIONS.Path = $path_conversion
    $env.Path = ($env.Path
        | split row (char esep)
        | prepend 'C:/Program Files/WinGet/Links'
        | prepend $'($env.LOCALAPPDATA)/Microsoft/WinGet/Links')
} else {
    $env.PATH_CONVERSIONS.PATH = $path_conversion
    $env.PATH = ($env.PATH | split row (char esep))
}

$env.Term = xterm-256color
$env.TERM = xterm-256color

mut $HOME = ""
if (is_windows)  {
    $HOME = $env.HOMEPATH
} else {
    $HOME = $env.HOME
}

# I set XDG BaseDirs in the ENV vs .profile so that I can use an XDG-like layout on Windows too
$env.XDG_CONFIG_HOME = $'($HOME)/.config/'

# TEMP: This was messing something up with nvim on Windows
#$env.XDG_CACHE_HOME = $'($HOME)/.cache/'

$env.EDITOR = nvim
$env.VISUAL = nvim

$env.BAT_CONFIG_PATH = $'($env.XDG_CONFIG_HOME)/bat/bat.conf'
$env.STARSHIP_CONFIG = $'($env.XDG_CONFIG_HOME)/starship/starship.toml'

# Custom command scripts
source '~/.config/nushell/scripts/git-gitignore.nu'
source '~/.config/nushell/scripts/git-ignore.nu'
source '~/.config/nushell/scripts/git-restage.nu'
source '~/.config/nushell/scripts/git-submodule-remove.nu'

# How Zoxide should be initialized
# but its not really useable if I keep updating nushell to latest.
# So I maintain my own version of zoxide.nu in ~/.config/nushell/scripts/zoxide.nu
#zoxide init nushell | save -f ~/.cache/zoxide.nu
