#!/usr/bin/env bats

# Fake mise and osascript log their calls. The fake mise runs what follows
# `x --` from its stub directory, where a fake colima also logs its calls.
setup() {
	bats_require_minimum_version 1.5.0
	export HOME=$BATS_TEST_TMPDIR/home
	export CALLS=$BATS_TEST_TMPDIR/calls
	STUBS=$HOME/.local/bin
	mkdir -p "$STUBS"
	cat >"$STUBS/mise" <<'STUB'
#!/bin/sh
echo "mise $* (in $PWD)" >>"$CALLS"
shift 2
"$@"
STUB
	cat >"$STUBS/colima" <<'STUB'
#!/bin/sh
echo "colima $*" >>"$CALLS"
STUB
	cat >"$STUBS/osascript" <<'STUB'
#!/bin/sh
echo "osascript $*" >>"$CALLS"
STUB
	chmod +x "$STUBS"/*
	PATH=$BATS_TEST_DIRNAME/../bin:/usr/bin:/bin
}

@test "start runs colima with mise's environment and says when Docker is up" {
	run -0 colima-notify start

	[ "$(cat "$CALLS")" = "mise x -- colima start (in $HOME)
colima start
osascript -e display notification \"Docker is running\" with title \"Colima\"" ]
}

@test "stop says when Docker has stopped" {
	run -0 colima-notify stop

	[ "$(tail -1 "$CALLS")" = "osascript -e display notification \"Docker has stopped\" with title \"Colima\"" ]
}

@test "says so when colima fails" {
	printf '#!/bin/sh\necho "level=fatal msg=\\"error starting vm\\"" >&2\nexit 1\n' >"$STUBS/colima"

	run -1 colima-notify start

	[ "$(tail -1 "$CALLS")" = "osascript -e display notification \"Run colima start in a terminal to see why\" with title \"Colima didn't start\"" ]
}
