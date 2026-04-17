#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PATH="$(dirname "$BASE")/bin:$PATH"
export PATH
# shellcheck disable=SC1091
source "$BASE"/lib-testing.sh
test-start addremove

# Setup Git
git init
git config user.name "git-kv-tests"
git config user.email "git-kv-tests@example.invalid"
date >run.log
git add -f run.log
git commit -m "Initial"

# Set a key
git-kv set test-key test-value
test-step "get returns initial key"
test-expect "$(git-kv get test-key)" "test-value"

# Override a key
git-kv set test-key test-value-overriden
test-step "get returns overridden key"
test-expect "$(git-kv get test-key)" "test-value-overriden"

git-kv set other-key other-key-value
test-step "get returns second key"
test-expect "$(git-kv get other-key)" "other-key-value"

# Delete key and ensure key is gone from current view
git-kv delete test-key
test-step "deleted key is empty"
test-expect "$(git-kv get test-key || true)" ""

# Exercise raw + json paths
test-step "list-all keeps deleted key history"
test-expect "$(git-kv list-all test-key)" "test-key"
test-step "notes ref exists"
test-exist .git/refs/notes/kv
test-step "json includes expected key"
if ! git-kv show -tjson | grep -q '"other-key":"other-key-value"'; then
	test-fail "JSON output did not contain expected key"
else
	test-ok
fi

# Commit scoping: child should not alter parent lookup
BASE_COMMIT="$(git rev-parse HEAD)"
date >>run.log
git add -f run.log
git commit -m "Second"
git-kv set branch-only value-only-on-second HEAD
test-step "head resolves branch-only value"
test-expect "$(git-kv get branch-only HEAD)" "value-only-on-second"
test-step "base commit has no branch-only value"
test-expect "$(git-kv get branch-only "$BASE_COMMIT" || true)" ""

# Ensure list-all/get-all/def honor commit argument
test-step "list-all honors commit argument"
test-expect "$(git-kv list-all branch-only "$BASE_COMMIT" || true)" ""
test-step "get-all honors commit argument"
test-expect "$(git-kv get-all branch-only "$BASE_COMMIT" || true)" ""
test-step "def honors commit argument"
test-expect "$(git-kv def branch-only "$BASE_COMMIT" || true)" ""

# Cleanup happens via trap in lib-testing.sh

# EOF
