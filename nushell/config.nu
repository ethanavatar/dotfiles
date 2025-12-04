
use ~/.config/nushell/share/nu_scripts/custom-completions/git/git-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/winget/winget-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/npm/npm-completions.nu *

$env.config.show_banner = false

$env.config.filesize.metric = false
$env.config.filesize.format = "auto"

