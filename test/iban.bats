#!/usr/bin/env bats

setup() {
	bats_require_minimum_version 1.5.0
	PATH=$BATS_TEST_DIRNAME/../bin:$PATH
}

# Moves the first four characters to the end, turns letters into numbers
# (A = 10 … Z = 35) and takes the remainder by 97 a digit at a time, as the
# number is too big for shell arithmetic. A valid IBAN leaves 1.
passes_mod97() {
	local rearranged=${1:4}${1:0:4} digits="" remainder=0 char i
	for ((i = 0; i < ${#rearranged}; i++)); do
		char=${rearranged:i:1}
		if [[ "$char" =~ [A-Z] ]]; then
			digits+=$(($(printf '%d' "'$char") - 55))
		else
			digits+=$char
		fi
	done
	for ((i = 0; i < ${#digits}; i++)); do
		remainder=$(((remainder * 10 + ${digits:i:1}) % 97))
	done
	[ "$remainder" -eq 1 ]
}

# The 11-test of old Dutch account numbers: 10·d1 + 9·d2 + … + 1·d10 is a
# multiple of 11. Some Dutch validators still apply it.
passes_11_test() {
	local account=$1 sum=0 i
	for i in 0 1 2 3 4 5 6 7 8 9; do
		sum=$((sum + (10 - i) * ${account:i:1}))
	done
	[ $((sum % 11)) -eq 0 ]
}

@test "prints a Dutch IBAN that passes the mod-97 check and the 11-test" {
	for _ in $(seq 200); do
		run -0 iban
		[[ "$output" =~ ^NL[0-9]{2}[A-Z]{4}[0-9]{10}$ ]]
		passes_mod97 "$output"
		passes_11_test "${output:8}"
	done
}
