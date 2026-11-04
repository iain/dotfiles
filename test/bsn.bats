#!/usr/bin/env bats

setup() {
	bats_require_minimum_version 1.5.0
	PATH=$BATS_TEST_DIRNAME/../bin:$PATH
}

# The elfproef: 9·d1 + 8·d2 + … + 2·d8 − d9 is a multiple of 11.
passes_elfproef() {
	local bsn=$1 sum=0 i
	[[ "$bsn" =~ ^[0-9]{9}$ ]] || return 1
	for i in 0 1 2 3 4 5 6 7; do
		sum=$((sum + (9 - i) * ${bsn:i:1}))
	done
	sum=$((sum - ${bsn:8:1}))
	[ $((sum % 11)) -eq 0 ]
}

@test "prints nine digits that pass the elfproef" {
	for _ in $(seq 200); do
		run -0 bsn
		passes_elfproef "$output"
	done
}
