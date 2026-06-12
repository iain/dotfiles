#!/usr/bin/env bash
# Claude Code status line: lead with the hostname so it is always obvious which
# machine a session is on. This is UI-only — the model never sees it (that is
# what hooks/machine-context.sh is for); it exists purely to orient the human.
input=$(cat)
host=$(scutil --get ComputerName 2>/dev/null || hostname -s)
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=${dir/#$HOME/\~}
model=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

# cyan host  ·  dir  ·  dim model  ·  dim context%
printf '\033[36m%s\033[0m  %s  \033[2m%s\033[0m' "$host" "$dir" "$model"
[ -n "$pct" ] && printf '  \033[2m%s%%\033[0m' "$pct"
