#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
for TEST in "$BASE"/*.sh; do
	case $TEST in
	*/lib-*.sh) ;;
	*/harness.sh) ;;
	*/*.sh)
		if bash "$TEST"; then
			echo "--- PASS $TEST"
		else
			echo "!!! FAIL $TEST"
			exit 1
		fi
		;;
	esac
done

# EOF
