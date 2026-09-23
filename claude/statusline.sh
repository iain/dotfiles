#!/usr/bin/env bash
# Claude Code status line: lead with the hostname so it is always obvious which
# machine a session is on. This is UI-only — the model never sees it (that is
# what hooks/machine-context.sh is for); it exists purely to orient the human.
#
#   host  repo[⧉wt]/subdir  branch  model·effort  tokens/window pct  $cost  [#pr] [⚡] [limits]
#
# (⧉ and # become Nerd Font glyphs, and the branch gains one, when
# STATUSLINE_NERDFONT is set.)
#
# Conditional segments only render when they are true, so an ordinary session
# stays short and the bar grows only when something is worth noticing.
#
# The location and the branch are the only segments that can grow without
# bound (worktree paths especially), so they are shortened to whatever width
# the other segments leave over in $COLUMNS.
#
# Payload reference: https://code.claude.com/docs/en/statusline.md

# UTF-8 so ${#s} and ${s:i:n} count characters, not bytes, for ⧉, ↑ and …
LC_ALL=en_US.UTF-8

input=$(cat)

# One jq pass. Token counts are humanised there (121423 -> 121k, 1000000 -> 1M)
# and cost is emitted as whole cents so bash never has to compare floats.
#
# Fields are joined with US (0x1f) rather than tab: `read` collapses runs of IFS
# *whitespace*, so an empty tab-separated field would silently shift every field
# after it. US is not whitespace, so empty fields survive.
IFS=$'\x1f' read -r dir model effort used tokens size pct cents fast pr r5 r7 < <(
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
    , (.effort.level // "")
    , (.context_window.total_input_tokens | human)
    , (.context_window.total_input_tokens // 0)
    , (.context_window.context_window_size | human)
    , (.context_window.used_percentage | whole)
    , ((.cost.total_cost_usd // 0) * 100 | round)
    , (.fast_mode // false)
    , (.pr.number // "")
    , (.rate_limits.five_hour.used_percentage | whole)
    , (.rate_limits.seven_day.used_percentage | whole)
    ] | map(tostring) | join("\u001f")'
)

esc=$'\033'
cyan="${esc}[36m" magenta="${esc}[35m" blue="${esc}[34m"
green="${esc}[32m" yellow="${esc}[33m" red="${esc}[31m"
dim="${esc}[2m" bold="${esc}[1m" reset="${esc}[0m"

# Nerd Font glyphs only where the terminal says it has the font (Ghostty sets
# STATUSLINE_NERDFONT), so an SSH session elsewhere shows no empty boxes. The
# Mono variant keeps them one cell wide, which the width fitting relies on.
if [ -n "$STATUSLINE_NERDFONT" ]; then
	worktree_mark=$'' # nf-oct-repo_forked
	pr_mark=$' '      # nf-oct-git_pull_request
	branch_mark=$' '  # nf-pl-branch
else
	worktree_mark="⧉"
	pr_mark="#"
	branch_mark=""
fi

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
	add "$colour" "$label $p%"
}

# Segments are kept as parallel colour and text arrays, so widths are measured
# on the plain text before any escape codes are added.
colours=() texts=()
add() {
	colours+=("$1")
	texts+=("$2")
}

# Shorten to $2 characters, keeping the start: a branch leads with its ticket.
keep_start() {
	if [ "${#1}" -le "$2" ]; then
		printf '%s' "$1"
	elif [ "$2" -lt 2 ]; then
		printf '…'
	else
		printf '%s…' "${1:0:$(($2 - 1))}"
	fi
}

# Share a width of $1 between two parts of length $2 and $3, setting first_max
# and second_max. A part shorter than its half hands the rest to the other one.
share() {
	local total=$1 half=$(($1 / 2))
	first_max=$2
	second_max=$3
	if [ $(($2 + $3)) -gt "$total" ]; then
		if [ "$2" -le "$half" ]; then
			second_max=$((total - $2))
		elif [ "$3" -le "$half" ]; then
			first_max=$((total - $3))
		else
			first_max=$half
			second_max=$((total - half))
		fi
	fi
}

# Shorten to $2 characters, keeping the end: the deepest directory matters most.
keep_end() {
	if [ "${#1}" -le "$2" ]; then
		printf '%s' "$1"
	elif [ "$2" -lt 2 ]; then
		printf '…'
	else
		printf '…%s' "${1: -$(($2 - 1))}"
	fi
}

# Like keep_end, but drop whole leading directories first: …/app/models.
keep_path_end() {
	local path=$1
	if [ "${#path}" -le "$2" ]; then
		printf '%s' "$path"
	else
		while [ $((${#path} + 1)) -gt "$2" ] && [[ $path == /*/* ]]; do
			path=/${path#/*/}
		done
		keep_end "…$path" "$2"
	fi
}

host=$(scutil --get ComputerName 2>/dev/null || hostname -s)

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

branch_marks=$dirty
[ "$ahead" -gt 0 ] && branch_marks+=" ↑$ahead"
[ "$behind" -gt 0 ] && branch_marks+=" ↓$behind"

# The location is shown from the repository root. In a linked worktree the
# common git dir still lives in the main checkout, which gives the repo name.
toplevel="" common=""
if [ -d "$dir" ]; then
	{
		IFS= read -r toplevel
		IFS= read -r common
	} < <(git --no-optional-locks -C "$dir" rev-parse --path-format=absolute --show-toplevel --git-common-dir 2>/dev/null)
fi

# The location is root, worktree label and tail. The root (repo name, or ~) is
# short and always shown whole. The label and the tail are shortened separately,
# so a narrow bar still shows a bit of both.
location_root="" worktree_label="" location_tail=$dir
if [ -n "$toplevel" ]; then
	main=${common%/.git}
	location_root=${main##*/}
	if [ "$toplevel" != "$main" ]; then
		location_root+=$worktree_mark
		# Worktrees are named after their branch with / as +, so the name only
		# adds something when it differs, as on a detached HEAD.
		worktree=${toplevel##*/}
		if [ "$worktree" != "${branch//\//+}" ]; then
			worktree_label=$worktree
		fi
	fi
	location_tail=${dir#"$toplevel"}
elif [ "${dir#"$HOME"}" != "$dir" ]; then
	location_root="~"
	location_tail=${dir#"$HOME"}
fi
location=$location_root$worktree_label$location_tail

add "$cyan" "$host"
location_index=-1
if [ -n "$location" ]; then
	location_index=${#texts[@]}
	add "" "$location"
fi
branch_index=-1
if [ -n "$branch" ]; then
	branch_index=${#texts[@]}
	add "$magenta" "$branch_mark$branch$branch_marks"
fi

if [ -n "$model" ]; then
	model_colour=$dim
	model_text=$model
	if [ -n "$effort" ]; then
		model_text+=" · $effort"
	fi
	# The top levels burn through the usage limits fastest.
	case $effort in
	xhigh | max) model_colour=$yellow ;;
	esac
	add "$model_colour" "$model_text"
fi

if [ -n "$used" ]; then
	context="$used"
	[ -n "$size" ] && context+="/$size"
	[ -n "$pct" ] && context+=" $pct%"
	add "$(context_heat "${pct:-0}" "${tokens:-0}")" "$context"
fi

[ "${cents:-0}" -gt 0 ] &&
	add "$dim" "$(printf '$%d.%02d' $((cents / 100)) $((cents % 100)))"
[ -n "$pr" ] && add "$blue" "$pr_mark$pr"
[ "$fast" = "true" ] && add "$bold$yellow" "⚡"

# The five-hour window is the one that actually gates you, so it is always on;
# the weekly window only speaks up once it is half gone.
window 5h "$r5" 0
window 7d "$r7" 50

# Whatever the fixed segments leave over is shared by the location and the
# branch.
columns=${COLUMNS:-0}
margin=4 floor=12
if [ "$columns" -gt 0 ]; then
	fixed=$((2 * (${#texts[@]} - 1) + margin + ${#branch_mark} + ${#branch_marks}))
	for i in "${!texts[@]}"; do
		if [ "$i" -ne "$location_index" ] && [ "$i" -ne "$branch_index" ]; then
			fixed=$((fixed + ${#texts[i]}))
		fi
	done

	share $((columns - fixed)) "${#location}" "${#branch}"
	location_max=$first_max
	branch_max=$second_max
	[ "$branch_max" -lt "$floor" ] && branch_max=$floor

	if [ "$location_index" -ge 0 ] && [ "${#location}" -gt "$location_max" ]; then
		room=$((location_max - ${#location_root}))
		[ "$room" -lt "$floor" ] && room=$floor
		# The directory you are in beats the worktree name, which the branch
		# usually repeats anyway.
		label_max=$((room / 3))
		if [ "${#worktree_label}" -lt "$label_max" ]; then
			label_max=${#worktree_label}
		fi
		label=$(keep_start "$worktree_label" "$label_max")
		tail=$(keep_path_end "$location_tail" $((room - label_max)))
		# Both cut: one ellipsis covers the gap.
		if [ "$label" != "$worktree_label" ]; then
			tail=${tail#…}
		fi
		texts[location_index]=$location_root$label$tail
	fi
	if [ "$branch_index" -ge 0 ]; then
		texts[branch_index]="$branch_mark$(keep_start "$branch" "$branch_max")$branch_marks"
	fi
fi

out=""
for i in "${!texts[@]}"; do
	if [ "$i" -gt 0 ]; then
		out+="  "
	fi
	out+="${colours[i]}${texts[i]}$reset"
done
printf '%s' "$out"
exit 0
