#!/usr/bin/env bats

# A fake caffeinate logs its arguments and stays alive until killed, like the
# real one, so the tests can see what runs and whether it's been stopped.
setup() {
	bats_require_minimum_version 1.5.0
	export XDG_STATE_HOME=$BATS_TEST_TMPDIR/state
	CAFFEINATE_LOG=$BATS_TEST_TMPDIR/caffeinate.log
	mkdir -p "$BATS_TEST_TMPDIR/stubs"
	cat >"$BATS_TEST_TMPDIR/stubs/caffeinate" <<STUB
#!/bin/bash
echo "\$*" >>"$CAFFEINATE_LOG"
while :; do sleep 1; done
STUB
	chmod +x "$BATS_TEST_TMPDIR/stubs/caffeinate"
	PATH=$BATS_TEST_DIRNAME/../bin:$BATS_TEST_TMPDIR/stubs:$PATH
}

teardown() {
	caffeine off >/dev/null 2>&1 || true
}

wait_for_log() {
	for _ in $(seq 50); do
		[ -s "$CAFFEINATE_LOG" ] && return 0
		sleep 0.1
	done
	return 1
}

@test "keeps the Mac awake for the given number of minutes" {
	run -0 caffeine 30 3>&-
	wait_for_log
	[ "$(cat "$CAFFEINATE_LOG")" = "-di -t 1800" ]
}

@test "off stops keeping the Mac awake" {
	caffeine 30 3>&-
	wait_for_log
	run -0 caffeine off
	run ! pgrep -f "$BATS_TEST_TMPDIR/stubs/caffeinate"
}

@test "a new duration replaces the running one" {
	caffeine 30 3>&-
	wait_for_log
	caffeine 60 3>&-
	run -0 pgrep -f "$BATS_TEST_TMPDIR/stubs/caffeinate"
	[ "${#lines[@]}" -eq 1 ]
}

@test "on keeps the Mac awake until stopped" {
	run -0 caffeine on 3>&-
	wait_for_log
	[ "$(cat "$CAFFEINATE_LOG")" = "-di" ]
}

@test "off leaves alone a process that reused the pid of a finished run" {
	sleep 30 3>&- &
	local unrelated=$!
	mkdir -p "$XDG_STATE_HOME"
	echo "$unrelated" >"$XDG_STATE_HOME/caffeine.pid"
	run -0 caffeine off
	kill -0 "$unrelated"
	kill "$unrelated"
}

@test "says until when the Mac stays awake" {
	run -0 caffeine 90 3>&-
	[ "$output" = "Awake until $(date -v+90M +%H:%M)" ]
	run -0 caffeine on 3>&-
	[ "$output" = "Awake until stopped" ]
	run -0 caffeine off
	[ "$output" = "The Mac can sleep again" ]
}
