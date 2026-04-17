#!/bin/sh

set -eu

REPO_RAW_URL="${REPO_RAW_URL:-https://raw.githubusercontent.com/sebastien/git-kv/main}"
TARGET_NAME="${TARGET_NAME:-git-kv}"

if [ -n "${BINDIR:-}" ]; then
	bindir="$BINDIR"
elif [ -n "${HOME:-}" ]; then
	bindir="$HOME/.local/bin"
else
	echo "HOME is not set. Please provide BINDIR." >&2
	exit 1
fi

target="${TARGET:-$bindir/$TARGET_NAME}"
source_url="$REPO_RAW_URL/bin/git-kv"

mkdir -p "$(dirname "$target")"

tmp_file="$(mktemp "${TMPDIR:-/tmp}/git-kv.XXXXXX")"
cleanup() {
	rm -f "$tmp_file"
}
trap cleanup EXIT INT TERM

if command -v curl >/dev/null 2>&1; then
	curl -fsSL "$source_url" -o "$tmp_file"
elif command -v wget >/dev/null 2>&1; then
	wget -qO "$tmp_file" "$source_url"
else
	echo "Missing downloader: install curl or wget." >&2
	exit 1
fi

chmod +x "$tmp_file"
mv "$tmp_file" "$target"

echo "Installed git-kv to $target"
