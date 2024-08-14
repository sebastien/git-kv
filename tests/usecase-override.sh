#!/bin/env bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$BASE"/lib-testing.sh
test-start override

# Setup Git and create initial commit
git init
echo "Initial content" > file.txt
git add file.txt
git commit -m "Initial commit"

# Set initial KV value
git-kv set test-key initial-value
initial_commit=$(git rev-parse HEAD)

# Create another commit and set another value for the same key
echo "Updated content" >> file.txt
git commit -am "Second commit"
git-kv set test-key updated-value

# Check that the current value for the key is the one previously set
test-expect $(git-kv get test-key) updated-value

# Check that the value for the key for the initial commit is as it should be
test-expect $(git-kv get test-key $initial_commit) initial-value

# EOF
