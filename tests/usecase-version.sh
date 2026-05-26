#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PATH="$(dirname "$BASE")/bin:$PATH"
export PATH
# shellcheck disable=SC1091
source "$BASE"/lib-testing.sh
test-start version

test-step "version flag prints version"
version_output="$(git-kv --version)"
if ! grep -Eq '^git-kv (dev|[0-9a-f]{7,}(-dirty)?)$' <<<"$version_output"; then
	test-fail "Unexpected version output: $version_output"
else
	test-ok
fi

test-step "version subcommand matches version flag"
test-expect "$(git-kv --version)" "$(git-kv -v)"

# Cleanup happens via trap in lib-testing.sh

# EOF
