load test_helper

# The palette runs as a herdr popup on top of the pane in $REPO, with herdr
# and fzf faked. Every list starts empty; tests fill in the ones they need.
setup() {
	setup_repos
	stub_herdr
	stub_fzf
	export HERDR_ACTIVE_PANE_ID=w1:p1
	export HERDR_ACTIVE_TAB_ID=w1:t1
	export HERDR_ACTIVE_PANE_CWD=$REPO
	herdr_replies "agent list" <<<'{"result": {"agents": []}}'
	herdr_replies "workspace list" <<<'{"result": {"workspaces": []}}'
	herdr_replies "worktree list" <<<'{"result": {"worktrees": []}}'
	herdr_replies "machine list" <<<'[]'
}

machines() {
	herdr_replies "machine list" <<'JSON'
[
  {"id": "402b1568b6abb4dabd1f0cb11e69cf27", "label": "tayaway", "target": "tayaway.nl", "enabled": true},
  {"id": "345dd5593c93673ee71ccfd80c91149a", "label": "m1", "target": "m1.lan", "enabled": false}
]
JSON
}

@test "offers each machine by label, with whichever of enable or disable applies" {
	machines

	run herdr-palette

	offered | grep -q '^machine  *disable tayaway  tayaway.nl$'
	offered | grep -q '^machine  *enable m1  m1.lan$'
}

@test "enabling a machine enables it by its id" {
	machines
	export FZF_PICK="enable m1"

	herdr-palette

	grep -qxF "machine enable 345dd5593c93673ee71ccfd80c91149a" "$HERDR_LOG"
}

@test "disabling a machine disables it by its id" {
	machines
	export FZF_PICK="disable tayaway"

	herdr-palette

	grep -qxF "machine disable 402b1568b6abb4dabd1f0cb11e69cf27" "$HERDR_LOG"
}

@test "lists agents that want attention first, without the one underneath" {
	herdr_replies "workspace list" <<<'{"result": {"workspaces": [{"workspace_id": "w2", "label": "api", "focused": false}]}}'
	herdr_replies "agent list" <<'JSON'
{"result": {"agents": [
  {"pane_id": "w2:p1", "workspace_id": "w2", "agent": "claude", "agent_status": "working", "state_change_seq": 9, "terminal_title_stripped": "Busy"},
  {"pane_id": "w2:p2", "workspace_id": "w2", "agent": "claude", "agent_status": "done", "state_change_seq": 3, "terminal_title_stripped": "Finished long ago"},
  {"pane_id": "w2:p3", "workspace_id": "w2", "agent": "claude", "agent_status": "done", "state_change_seq": 7, "terminal_title_stripped": "Finished just now"},
  {"pane_id": "w2:p4", "workspace_id": "w2", "agent": "codex", "agent_status": "blocked", "state_change_seq": 1},
  {"pane_id": "w1:p1", "workspace_id": "w2", "agent": "claude", "agent_status": "blocked", "state_change_seq": 8, "terminal_title_stripped": "Me"}
]}}
JSON

	run herdr-palette

	[ "$(offered | grep '^agent' | sed 's/^agent  *//')" = "$(printf '%s\n' \
		"× codex  api" \
		"✓ Finished just now  api" \
		"✓ Finished long ago  api" \
		"◐ Busy  api")" ]
}

@test "picking an agent focuses its pane" {
	herdr_replies "agent list" <<<'{"result": {"agents": [{"pane_id": "w2:p1", "workspace_id": "w2", "agent": "claude", "agent_status": "idle", "state_change_seq": 1, "terminal_title_stripped": "Refactor"}]}}'
	export FZF_PICK="Refactor"

	herdr-palette

	grep -qxF "agent focus w2:p1" "$HERDR_LOG"
}

@test "picking a workspace focuses it, and the focused one isn't offered" {
	herdr_replies "workspace list" <<'JSON'
{"result": {"workspaces": [
  {"workspace_id": "w1", "label": "here", "focused": true},
  {"workspace_id": "w2", "label": "elsewhere", "focused": false}
]}}
JSON
	export FZF_PICK="elsewhere"

	herdr-palette

	[ "$(offered | grep '^workspace' | sed 's/  *$//')" = "workspace elsewhere" ]
	grep -qxF "workspace focus w2" "$HERDR_LOG"
}

@test "offers worktrees without a workspace, and picking one opens it" {
	herdr_replies "worktree list" <<JSON
{"result": {"worktrees": [
  {"path": "$REPO", "branch": "main", "is_bare": false, "open_workspace_id": "w1"},
  {"path": "$HOME/Code/worktrees/app/feature", "branch": "feature", "is_bare": false, "open_workspace_id": null}
]}}
JSON
	export FZF_PICK="feature"

	herdr-palette

	[ "$(offered | grep '^worktree')" = "worktree  feature  ~/Code/worktrees/app/feature" ]
	grep -qxF "worktree open --cwd $REPO --path $HOME/Code/worktrees/app/feature --focus" "$HERDR_LOG"
}

@test "typing what matches nothing creates a worktree with that branch name" {
	export FZF_QUERY="  fix the login bug "

	herdr-palette

	[ "$(git -C "$HOME/Code/worktrees/app/fix-the-login-bug" branch --show-current)" = "fix-the-login-bug" ]
	grep -qxF "worktree open --cwd $REPO --path $HOME/Code/worktrees/app/fix-the-login-bug --focus" "$HERDR_LOG"
}

@test "typing an invalid branch name says so and creates nothing" {
	export FZF_QUERY="bad..name"

	run herdr-palette </dev/null

	[ "$status" -ne 0 ]
	[[ "$output" == *'"bad..name" is not a valid branch name'* ]]
	[ ! -e "$HOME/Code/worktrees" ]
}

@test "outside a git repo, typing what matches nothing does nothing" {
	mkdir "$BATS_TEST_TMPDIR/plain"
	export HERDR_ACTIVE_PANE_CWD=$BATS_TEST_TMPDIR/plain
	export FZF_QUERY="anything"

	run herdr-palette

	[ "$status" -eq 0 ]
	[ ! -e "$HOME/Code/worktrees" ]
}

@test "escape does nothing" {
	run herdr-palette

	[ ! -e "$HOME/Code/worktrees" ]
	[ -z "$(grep -v ' list' "$HERDR_LOG")" ]
}

@test "new tab opens one in the pane's directory" {
	export FZF_PICK="new tab here"

	herdr-palette

	grep -qxF "tab create --cwd $REPO --focus" "$HERDR_LOG"
}

@test "rename tab renames the tab underneath" {
	export FZF_PICK="rename this tab"

	herdr-palette <<<"notes"

	grep -qxF "tab rename w1:t1 notes" "$HERDR_LOG"
}

@test "move pane moves the pane underneath to the picked workspace" {
	herdr_replies "workspace list" <<<'{"result": {"workspaces": [{"workspace_id": "w2", "label": "api", "focused": false}]}}'
	export FZF_PICK=$'move this pane\napi'

	herdr-palette

	grep -qxF "pane move w1:p1 --new-tab --workspace w2 --focus" "$HERDR_LOG"
}

@test "reload config reloads herdr's config" {
	export FZF_PICK="reload herdr config"

	herdr-palette

	grep -qxF "server reload-config" "$HERDR_LOG"
}
