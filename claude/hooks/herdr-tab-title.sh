#!/usr/bin/env bash
# Stop hook: name the herdr tab after the Claude session. Claude puts the
# session name (from /rename or --name, otherwise its generated title) in the
# terminal title, which herdr keeps per pane. A tab is only renamed while it
# holds just this pane and still has herdr's generated number, or the label
# this hook gave it, so tab names typed by hand stay.
[ -n "$HERDR_TAB_ID" ] && [ -n "$HERDR_PANE_ID" ] || exit 0

herdr=${HERDR_BIN_PATH:-herdr}
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/claude/herdr-tab-labels
state_file=$state_dir/$HERDR_TAB_ID

title=$("$herdr" pane get "$HERDR_PANE_ID" | jq -r '.result.pane.terminal_title_stripped // empty')
tab=$("$herdr" tab get "$HERDR_TAB_ID")
label=$(jq -r '.result.tab.label' <<<"$tab")
pane_count=$(jq -r '.result.tab.pane_count' <<<"$tab")
last_set=$(cat "$state_file" 2>/dev/null)

# Before Claude has a title for the session, the terminal title is its name.
session_has_title() {
  [ -n "$title" ] && [ "$title" != "Claude Code" ]
}

tab_is_ours() {
  [ "$pane_count" = 1 ] && { [[ $label =~ ^[0-9]+$ ]] || [ "$label" = "$last_set" ]; }
}

if session_has_title && tab_is_ours && [ "$title" != "$label" ]; then
  "$herdr" tab rename "$HERDR_TAB_ID" "$title" >/dev/null
  mkdir -p "$state_dir"
  printf '%s' "$title" >"$state_file"
fi
