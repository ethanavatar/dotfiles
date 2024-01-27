
use ~/.config/nushell/share/nu_scripts/custom-completions/git/git-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/winget/winget-completions.nu *
use ~/.config/nushell/share/nu_scripts/custom-completions/npm/npm-completions.nu *

source ~/.config/nushell/aliases.nu

$env.config.show_banner = false

$env.config.filesize.metric = false
$env.config.filesize.format = "auto"

# Starship prompt
export-env { load-env {
    STARSHIP_SHELL: "nu"
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        starship prompt --continuation
    )
    PROMPT_INDICATOR: ""

    PROMPT_COMMAND: {||
        (
            starship prompt
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            starship prompt
                --right
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }
}}

source ~/.config/nushell/scripts/zoxide-init.nu
