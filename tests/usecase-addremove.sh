#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$BASE"/lib-testing.sh
test-start addremove

# Setup Git
git init
date >run.log
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

echo "POUET"
git-kv show

# git-kv delete test-key
# test-expect $(git-kv get test-key) ""

# EOF
