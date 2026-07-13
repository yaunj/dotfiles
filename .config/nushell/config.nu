# https://www.followtheprocess.codes/posts/macos-env-vars/

$env.config.show_banner = "short"
$env.config.buffer_editor = "nvim"

# OS specific stuff
match (sys host | get name) {
  "Darwin" => {
    $env.config.use_kitty_protocol = true
  }
  "Windows" => {
    $env.Path = ($env.Path | prepend 'C:\Program Files\Git\usr\bin')
  }
}

alias fg = job unfreeze

source "~/.config/nushell/prompt.nu"

const cargo_env = "~/.cargo/env.nu"
const cargo_env_load = if ($cargo_env | path exists) { $cargo_env } else { null }
source $cargo_env_load
source "~/.cargo/env.nu"
source "~/.config/nushell/completions/jj.nu"
