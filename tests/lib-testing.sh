#!/usr/bin/env bash

# --
# Primitives for testing

set -euo pipefail

ORIGINAL_PATH="$PWD"
BASE_PATH="$(dirname "$(dirname "$(readlink -f "$0")")")"
TEST_NAME="$(basename "$0" | cut -d. -f1)"
TEST_PATH=""
TEST_ERRORS=()
TEST_LOG=()
TEST_CLEAN=()

function test-start {
	if [ -n "$TEST_PATH" ]; then
		test-cleanup
	fi
	TEST_PATH=$(realpath $(mktemp -d tmp.testing.XXX))
	TEST_NAME="${1:-$TEST_NAME}"
	if [ -z "$TEST_PATH" ] || [ ! -d "$TEST_PATH" ]; then
		test-error "Path empty or does not exists: '$TEST_PATH'"
		return 1
	fi
	test-log "Starting in: $TEST_PATH"
	cd "$TEST_PATH"
}

function test-diff {
	local a=$(mktemp "$TEST_PATH"/var.XXX)
	local b=$(mktemp "$TEST_PATH"/var.XXX)
	echo "$1" > "$a"
	echo "$2" > "$b"
	echo "--- Expected/Retrieved"
	diff "$a" "$b"
	echo "---"
	unlink "$a"
	unlink "$b"
}

function test-expect {
	if [ "$1" != "$2" ]; then
		test-fail "Output differ"
		test-diff "$1" "$2"
	else
		test-succeeds 
	fi
}
function test-error {
	echo "[$TEST_NAME] !!! $@"
}

function test-log {
	echo "[$TEST_NAME] ... $@"
}

function test-abort {
	echo "$@" >/dev/stderr
	TEST_ERRORS+=("F")
	test-cleanup
}

function test-succeeds {
	if [ ! -s "$@" ]; then echo "... $*" >/dev/stderr; else echo "... OK" >/dev/stderr; fi
	TEST_LOG+=("✓")
}

function test-fail {
	local i=0
	local line_number
	local file_path
	local relative_path
	# NOTE: This crashed and makes the function exist, not sure why.
	# while [[ "${BASH_SOURCE[i]}" == *"lib-testing.sh" ]]; do
	# 	echo "X${BASH_SOURCE[i]}"
	# 	((i++))
	# done
	line_number="${BASH_LINENO[$((i-1))]}"
	file_path="${BASH_SOURCE[$i]}"
	relative_path=$(realpath --relative-to="$ORIGINAL_PATH" "$file_path")

	if [ ! -z "$@" ]; then
		echo "!!! FAIL at $relative_path:$line_number: $*" >/dev/stderr
	else
		echo "!!! FAIL at $relative_path:$line_number" >/dev/stderr
	fi
	TEST_LOG+=("×")
	TEST_ERRORS+=("F")
}

function test-err {
	echo "$@" >/dev/stderr
	TEST_LOG+=("×")
	TEST_ERRORS+=("E")
}

function test-data {
	local data_path="$BASE_PATH/tests/data/$1"
	if [ -n "$1" ] && [ -e "$data_path" ]; then
		echo -n "$data_path"
	elif [ -z "$1" ]; then
		test-err "-!- ERR 'test-data FILENAME' is missing FILENAME argument"
		exit 1
	else
		test-err "!!! ERR Could not find test data: path=$data_path"
		exit 1
	fi
}

function test-cleanup {
	if [ -e "$TEST_PATH" ]; then
		rm -rf "$TEST_PATH"
	fi
	for path in "${TEST_CLEAN[@]}"; do
		if [ -d "$path" ]; then
			rm -rf "$path"
		elif [ -e "$path" ]; then
			unlink "$path"
		fi
	done
	if [ ${#TEST_ERRORS[@]} -eq 0 ]; then
		test-log "EOK [${TEST_LOG[@]}]"
		return 0
	else
		test-log "EFAIL [${TEST_LOG[@]}] ${TEST_ERRORS[@]}"
		return 1
	fi
}

function test-path {
	if [ ! -e "$BASE_PATH/.deps/run" ]; then mkdir -p "$BASE_PATH/.deps/run"; fi
	TEST_PATH="$(mktemp -d -p "$BASE_PATH/.deps/run" "$TEST_NAME.test.XXXXX")"
	export TEST_PATH
	mkdir -p "$TEST_PATH"
	cd "$ORIGINAL_PATH"
	echo -n "$TEST_PATH"
}

function test-exist {
	for path in "$@"; do
		if [ ! -e "$path" ]; then
			test-fail "Path does not exists: $path"
		else
			test-succeeds
		fi
	done
}

function test-empty {
	local name="$1"
	local value="$2"
	local failure="$3"
	test-log "--- TEST $name"
	if [ -s "$value" ]; then
		test-fail "$failure"
	else
		test-succeeds
	fi
}

trap test-cleanup EXIT

# EOF
