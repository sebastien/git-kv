#!/bin/env/bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
for TEST in $BASE/*.*; do
	case $TEST in
		*/lib-*.sh)
			;;
		*/harness.sh)
			;;
		*/*.sh)
			if . "$TEST"; then
				echo "--- PASS $TEST"
			else
				echo "!!! FAIL $TEST"
			fi
		;;
	esac
done

# EOF

