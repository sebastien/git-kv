#!/bin/env/bash
set -euo pipefail

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PATH="$(dirname "$BASE")/bin:$PATH"
export PATH
# shellcheck disable=SC1091
source "$BASE"/lib-testing.sh
test-start specialchars

# Setup Git
git init
git config user.name "git-kv-tests"
git config user.email "git-kv-tests@example.invalid"
date >run.log
git add -f run.log
git commit -m "Initial"

# Keys with regex metacharacters are treated literally for set/delete replacement.
git-kv set 'regex.*[k]' first-value
git-kv set regex123 keep-me
test-step "regex-like key does not affect literal key"
test-expect "$(git-kv get regex123)" "keep-me"
test-step "regex-like key stored literally"
if ! git-kv show | grep -Fq 'regex.*[k]:first-value'; then
	test-fail "Literal regex-like key was not stored"
else
	test-ok
fi

git-kv set 'regex.*[k]' second-value
test-step "literal key remains after update"
test-expect "$(git-kv get regex123)" "keep-me"
test-step "regex-like key updates literally"
if ! git-kv show | grep -Fq 'regex.*[k]:second-value'; then
	test-fail "Literal regex-like key was not updated"
else
	test-ok
fi

git-kv delete 'regex.*[k]'
test-step "literal key remains after delete"
test-expect "$(git-kv get regex123)" "keep-me"
test-step "delete writes literal tombstone"
if git-kv show | grep -Fq 'regex.*[k]:'; then
	test-ok
else
	test-fail "Delete tombstone for literal regex-like key is missing"
fi

# Value escaping should remain intact through storage and JSON output.
SPECIAL_VALUE='percent%quote"back\slash'
git-kv set special-value "$SPECIAL_VALUE"
test-step "value round-trips with escapes"
test-expect "$(git-kv get special-value)" "$SPECIAL_VALUE"

test-step "json escapes quote and backslash"
if ! git-kv show -tjson | grep -Fq '"special-value":"percent%quote\"back\\slash"'; then
	test-fail "JSON output did not escape quote/backslash as expected"
else
	test-ok
fi

# Cleanup happens via trap in lib-testing.sh

# EOF
