#!/usr/bin/env bash
# Claude Code status line: lead with the hostname so it is always obvious which
# machine a session is on. This is UI-only — the model never sees it (that is
# what hooks/machine-context.sh is for); it exists purely to orient the human.
#
#   host  dir  branch  model  tokens/window pct  $cost  [wt] [#pr] [⚡] [limits]
#
# Conditional segments only render when they are true, so an ordinary session
# stays short and the bar grows only when something is worth noticing.
#
# Payload reference: https://code.claude.com/docs/en/statusline.md

LC_ALL=C # keep printf's decimal separator predictable

input=$(cat)

# One jq pass. Token counts are humanised there (121423 -> 121k, 1000000 -> 1M)
# and cost is emitted as whole cents so bash never has to compare floats.
#
# Fields are joined with US (0x1f) rather than tab: `read` collapses runs of IFS
# *whitespace*, so an empty tab-separated field would silently shift every field
# after it. US is not whitespace, so empty fields survive.
IFS=$'\x1f' read -r dir model used tokens size pct cents fast worktree pr r5 r7 < <(
	printf '%s' "$input" | jq -j '
    def human:
      if . == null then ""
      elif . >= 1000000 then (. / 1000000 * 10 | round / 10 | tostring) + "M"
      elif . >= 10000   then (. / 1000 | round | tostring) + "k"
      elif . >= 1000    then (. / 1000 * 10 | round / 10 | tostring) + "k"
      else tostring end;
    def whole: if . == null then "" else (tostring | split(".")[0]) end;
    [ (.workspace.current_dir // .cwd // "")
    , (.model.display_name // "")
    , (.context_window.total_input_tokens | human)
    , (.context_window.total_input_tokens // 0)
    , (.context_window.context_window_size | human)
    , (.context_window.used_percentage | whole)
    , ((.cost.total_cost_usd // 0) * 100 | round)
    , (.fast_mode // false)
    , (.workspace.git_worktree // .worktree.name // "")
    , (.pr.number // "")
    , (.rate_limits.five_hour.used_percentage | whole)
    , (.rate_limits.seven_day.used_percentage | whole)
    ] | map(tostring) | join("\u001f")'
)

esc=$'\033'
cyan="${esc}[36m" magenta="${esc}[35m" blue="${esc}[34m"
green="${esc}[32m" yellow="${esc}[33m" red="${esc}[31m"
dim="${esc}[2m" bold="${esc}[1m" reset="${esc}[0m"

# Absolute token count at which the context segment goes yellow. Percentage is
# the wrong warning for a 1M window — 10% full is still 100k tokens, which is
# already enough to be worth noticing.
context_warn_tokens=100000

# Colour a percentage by how much headroom is left.
heat() {
	if [ "$1" -ge 80 ]; then
		printf '%s' "$red"
	elif [ "$1" -ge 50 ]; then
		printf '%s' "$yellow"
	else
		printf '%s' "$green"
	fi
}

# Context is warned on two axes: relative (the window is nearly full) and
# absolute (the transcript is simply large).
context_heat() {
	local pct=$1 tokens=$2
	if [ "$pct" -ge 80 ]; then
		printf '%s' "$red"
	elif [ "$tokens" -ge "$context_warn_tokens" ]; then
		printf '%s' "$yellow"
	else
		printf '%s' "$green"
	fi
}

# A usage window, dim while it is nothing to think about.
window() {
	local label=$1 p=$2 floor=$3 colour=$dim
	[ -z "$p" ] && return
	[ "$p" -lt "$floor" ] && return
	[ "$p" -ge 50 ] && colour=$(heat "$p")
	printf '%s%s %s%%%s' "$colour" "$label" "$p" "$reset"
}

host=$(scutil --get ComputerName 2>/dev/null || hostname -s)
segments=("$cyan$host$reset")
[ -n "$dir" ] && segments+=("${dir/#$HOME/\~}")

# Branch, dirtiness and ahead/behind all come out of one porcelain=v2 call, which
# is cheaper than asking git three times. Untracked files are excluded: build
# output and scratch files would leave the monorepo permanently marked dirty.
branch="" dirty="" ahead=0 behind=0
while IFS= read -r line; do
	case $line in
	"# branch.head "*) branch=${line#\# branch.head } ;;
	"# branch.ab "*)
		ab=${line#\# branch.ab }
		ahead=${ab%% *} behind=${ab##* }
		ahead=${ahead#+} behind=${behind#-}
		;;
	"#"*) ;;
	?*) dirty="*" ;;
	esac
done < <([ -d "$dir" ] && git --no-optional-locks -C "$dir" status --porcelain=v2 --branch --untracked-files=no 2>/dev/null)

if [ -n "$branch" ]; then
	branch+=$dirty
	[ "$ahead" -gt 0 ] && branch+=" ↑$ahead"
	[ "$behind" -gt 0 ] && branch+=" ↓$behind"
	segments+=("$magenta$branch$reset")
fi

[ -n "$worktree" ] && segments+=("$dim⧉ $worktree$reset")
[ -n "$model" ] && segments+=("$dim$model$reset")

if [ -n "$used" ]; then
	context="$used"
	[ -n "$size" ] && context+="/$size"
	[ -n "$pct" ] && context+=" $pct%"
	segments+=("$(context_heat "${pct:-0}" "${tokens:-0}")$context$reset")
fi

[ "${cents:-0}" -gt 0 ] &&
	segments+=("$dim$(printf '$%d.%02d' $((cents / 100)) $((cents % 100)))$reset")
[ -n "$pr" ] && segments+=("$blue#$pr$reset")
[ "$fast" = "true" ] && segments+=("$bold$yellow⚡$reset")

# The five-hour window is the one that actually gates you, so it is always on;
# the weekly window only speaks up once it is half gone.
for w in "$(window 5h "$r5" 0)" "$(window 7d "$r7" 50)"; do
	[ -n "$w" ] && segments+=("$w")
done

printf '%s' "${segments[0]}"
[ ${#segments[@]} -gt 1 ] && printf '  %s' "${segments[@]:1}"
exit 0
