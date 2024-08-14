#!/bin/env bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$BASE"/lib-testing.sh
test-start pushpull

# Create repository A
mkdir repo-a
cd repo-a
git init
echo "Initial content" > file.txt
git add file.txt
git commit -m "Initial commit in A"
git-kv set key-a value-a

# Clone repository A as B
cd ..
git clone repo-a repo-b
cd repo-b

# Add a commit and a key/value in B
echo "Content from B" >> file.txt
git commit -am "Commit in B"
git-kv set key-b value-b

# Push changes from B
git push origin main
git-kv push

# Pull B into A and validate
cd ../repo-a
git pull origin main
git-kv pull
test-expect $(git-kv get key-b) value-b

# Add another key/value in A
git-kv set key-c value-c
git-kv push

# Pull A into B and validate
cd ../repo-b
git-kv pull
test-expect $(git-kv get key-c) value-c

# Cleanup
cd ..
rm -rf repo-a repo-b

# EOF
