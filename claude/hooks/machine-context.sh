#!/usr/bin/env bash
# SessionStart hook: tell the model which physical machine it is running on.
# Claude Code's environment block omits the hostname, which once led it to
# guess the wrong machine (inferring from an SSH key label instead). Inject the
# fact directly so it never has to guess. Fires on every session start.
name=$(scutil --get ComputerName 2>/dev/null || hostname -s)
short=$(hostname -s)
ctx="You are running on the machine \"$name\" (hostname: $short, user: $USER). Trust this over any inferred signal — e.g. SSH key labels or repo contents — when reasoning about which machine you are on."

# Inside herdr, point Claude at it for anything that needs its own terminal.
if [ "$HERDR_ENV" = 1 ]; then
  ctx="$ctx

This session runs in a herdr pane (workspace $HERDR_WORKSPACE_ID, tab $HERDR_TAB_ID, pane $HERDR_PANE_ID). When a task needs another terminal, a long-running process the user should be able to watch, or another agent, use herdr panes, tabs or workspaces through the \`herdr\` CLI (the herdr skill, or \`herdr --skill\`, explains it) rather than opening Ghostty windows, osascript or tmux."
fi

jq -n --arg ctx "$ctx" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
