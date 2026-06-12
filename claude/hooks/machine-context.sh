#!/usr/bin/env bash
# SessionStart hook: tell the model which physical machine it is running on.
# Claude Code's environment block omits the hostname, which once led it to
# guess the wrong machine (inferring from an SSH key label instead). Inject the
# fact directly so it never has to guess. Fires on every session start.
name=$(scutil --get ComputerName 2>/dev/null || hostname -s)
short=$(hostname -s)
ctx="You are running on the machine \"$name\" (hostname: $short, user: $USER). Trust this over any inferred signal — e.g. SSH key labels or repo contents — when reasoning about which machine you are on."

jq -n --arg ctx "$ctx" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
