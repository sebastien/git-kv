#!/usr/bin/env bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PATH="$(dirname "$BASE")/bin:$PATH"
export PATH
# shellcheck disable=SC1091
source "$BASE"/lib-testing.sh
test-start unborn-head

git init

test-step "show is empty on unborn head"
test-expect "$(git-kv show)" ""

test-step "list is empty on unborn head"
test-expect "$(git-kv list)" ""

test-step "list-all is empty on unborn head"
test-expect "$(git-kv list-all)" ""

test-step "get is empty on unborn head"
test-expect "$(git-kv get test-key)" ""

test-step "get-all is empty on unborn head"
test-expect "$(git-kv get-all test-key)" ""

test-step "def is empty on unborn head"
test-expect "$(git-kv def test-key)" ""

test-step "invalid commit still fails"
test-expect-failure git-kv list test-key does-not-exist

# Cleanup happens via trap in lib-testing.sh

# EOF
