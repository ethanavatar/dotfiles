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

# Tell programs to use true color
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
$env.XDG_CACHE_HOME = $'($HOME)/.cache/'
$env.XDG_DATA_HOME = $'($HOME)/.local/share/'
$env.XDG_STATE_HOME = $'($HOME)/.local/state/'
$env.XDG_RUNTIME_DIR = $'($HOME)/.local/run/'

# Set XDG user directories
$env.XDG_DESKTOP_DIR = $'($HOME)/Desktop'
$env.XDG_DOCUMENTS_DIR = $'($HOME)/Documents'
$env.XDG_DOWNLOAD_DIR = $'($HOME)/Downloads'
$env.XDG_MUSIC_DIR = $'($HOME)/Music'
$env.XDG_PICTURES_DIR = $'($HOME)/Pictures'
$env.XDG_VIDEOS_DIR = $'($HOME)/Videos'
#$env.XDG_PUBLICSHARE_DIR = $'($HOME)/Public'
#$env.XDG_TEMPLATES_DIR = $'($HOME)/Templates'

$env.EDITOR = nvim
$env.VISUAL = nvim

$env.BAT_CONFIG_PATH = $'($env.XDG_CONFIG_HOME)/bat.conf'
$env.STARSHIP_CONFIG = $'($env.XDG_CONFIG_HOME)/starship.toml'

# Custom command scripts
source '~/.config/nushell/scripts/git-gitignore.nu'
source '~/.config/nushell/scripts/git-ignore.nu'
source '~/.config/nushell/scripts/git-restage.nu'
source '~/.config/nushell/scripts/git-submodule-remove.nu'
source '~/.config/nushell/scripts/git-subfolder-checkout.nu'
source '~/.config/nushell/scripts/killall.nu'
source '~/.config/nushell/scripts/ndk-env.nu'
source '~/.config/nushell/scripts/mkv-remux.nu'
source '~/.config/nushell/scripts/nufetch.nu'

# How Zoxide should be initialized
# but its not really useable if I keep updating nushell to latest.
# So I maintain my own version of zoxide.nu in ~/.config/nushell/scripts/zoxide.nu
#zoxide init nushell | save -f ~/.cache/zoxide.nu
