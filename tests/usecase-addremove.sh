#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$BASE"/lib-testing.sh
test-start addremove

# Setup Git
git init
date > run.log
git add run.log
git commit -m "Initial"

# Set a key
git-kv set test-key test-value
test-expect $(git-kv get test-key) test-value

# Override a key
git-kv set test-key test-value-overriden
test-expect $(git-kv get test-key) test-value-overriden

# # Set another key 
git-kv set other-key other-key-value
# test-expect $(git-kv get other-key) other-key-value

# Test git-kv show
show_output=$(git-kv show)
expected_output="test-key:test-value-overriden
other-key:other-key-value"
test-expect "$show_output" "$expected_output"

# Test deletion
git-kv delete test-key
test-expect "$(git-kv get test-key)" ""

# Verify show output after deletion
show_output_after_delete=$(git-kv show)
expected_output_after_delete="other-key:other-key-value
test-key:"
test-expect "$show_output_after_delete" "$expected_output_after_delete"

# EOF
