use std

def yaunj-path [] {
  let $pwd = $env.PWD
  let $repo_info = (do -i { git rev-parse --show-toplevel err> (std null-device) } | complete)
  let $repo_root = if $repo_info.exit_code == 0 { $repo_info.stdout | str trim } else { "" }

  if ($repo_root | is-empty) {
    match (do -i { $pwd | path relative-to $nu.home-dir }) {
      null => $pwd
      '' => '~'
      $relative => ([~ $relative] | path join)
    }
  } else {
    let $repo_name = $"($repo_root | path basename):"
    let $rel_path = ($pwd | path relative-to $repo_root)

    if ($rel_path == "." or $rel_path == "") {
      $"($repo_name)(char path_sep)"
    } else {
      ([$repo_name $rel_path] | path join)
    }
  }
}

$env.PROMPT_INDICATOR = "% "
$env.PROMPT_COMMAND_RIGHT = {
  let $time_part = (date now | format date "%H:%M")

  $"($time_part)"
}
$env.PROMPT_COMMAND = {
  let $exit_part = if $env.LAST_EXIT_CODE != 0 { $"err:(ansi red)($env.LAST_EXIT_CODE)(ansi reset) " } else { "" }
  let $jobs_count = (job list | length)
  let $jobs_part = if $jobs_count > 0 { $"bg:($jobs_count) " } else { "" }
  let $path_color = (if (is-admin) { ansi red_bold } else { ansi yellow_underline })

  $"(ansi reset)($jobs_part)($path_color)(yaunj-path)(ansi reset)(char lf)($exit_part)"
}
$env.TRANSIENT_PROMPT_COMMAND = {
  let $path_color = (if (is-admin) { ansi red_bold } else { ansi yellow_underline })
  $"(ansi reset)($path_color)(yaunj-path)(ansi reset)"
}
