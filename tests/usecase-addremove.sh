# #!/usr/bin/env bash
# set -euo pipefail
# BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# source "$BASE"/testing.sh
# 
# 
# # Create a temporary directory
# temp_dir=$(mktemp -d)
# cd "$temp_dir"
# 
# # Initialize git repository and create an initial commit
# git init
# touch README.md
# git add README.md
# git commit -m "Initial commit"
# 
# # Function to run git-kv and capture output
# run_git_kv() {
#     "$@"
# }
# 
# # Test 1: Adding a key
# echo "Test 1: Adding a key"
# run_git_kv git kv set test-key test-value
# output=$(run_git_kv git kv show)
# if [[ "$output" == *"test-key:test-value"* ]]; then
#     echo "PASS: Key was added successfully"
# else
#     echo "FAIL: Key was not added"
#     exit 1
# fi
# 
# # Test 2: Adding the same key twice
# echo "Test 2: Adding the same key twice"
# run_git_kv git kv set test-key new-value
# output=$(run_git_kv git kv show)
# if [[ "$output" == *"test-key:new-value"* ]] && [[ "$output" != *"test-key:test-value"* ]]; then
#     echo "PASS: Key was overridden successfully"
# else
#     echo "FAIL: Key was not overridden"
#     exit 1
# fi
# 
# # Test 3: Adding another key
# echo "Test 3: Adding another key"
# run_git_kv git kv set another-key another-value
# output=$(run_git_kv git kv show)
# if [[ "$output" == *"test-key:new-value"* ]] && [[ "$output" == *"another-key:another-value"* ]]; then
#     echo "PASS: Both keys are present"
# else
#     echo "FAIL: Both keys are not present"
#     exit 1
# fi
# 
# # Test 4: Deleting a key
# echo "Test 4: Deleting a key"
# run_git_kv git kv delete test-key
# output=$(run_git_kv git kv show)
# if [[ "$output" != *"test-key:"* ]] && [[ "$output" == *"another-key:another-value"* ]]; then
#     echo "PASS: Key was deleted successfully"
# else
#     echo "FAIL: Key was not deleted"
#     exit 1
# fi
# 
# # Clean up
# cd
# rm -rf "$temp_dir"
# 
# echo "All tests passed successfully!"
# # EOF
