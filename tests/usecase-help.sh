#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PATH="$(dirname "$BASE")/bin:$PATH"
export PATH
# shellcheck disable=SC1091
source "$BASE"/lib-testing.sh
test-start help

test-step "help flag matches help subcommand"
test-expect "$(git-kv --help)" "$(git-kv help)"

test-step "help output lists subcommands"
help_output="$(git-kv --help)"
help_ok="true"
for expected in \
	"show [COMMIT]" \
	"del|delete KEY [COMMIT]" \
	"set [-f|--force] KEY VALUE [COMMIT]" \
	"get KEY [COMMIT]" \
	"def KEY [COMMIT]" \
	"get-all KEY [COMMIT]" \
	"list KEYISH [COMMIT]" \
	"list-all KEYISH [COMMIT]" \
	"items [KEYISH] [COMMIT]" \
	"push [ORIGIN]" \
	"pull [ORIGIN]" \
	"help" \
	"-h, --help"
do
	if ! grep -Fq -- "$expected" <<<"$help_output"; then
		test-fail "Help output missing: $expected"
		help_ok="false"
		break
	fi
done
if [ "$help_ok" = "true" ]; then
	test-ok
fi

# Cleanup happens via trap in lib-testing.sh

# EOF
