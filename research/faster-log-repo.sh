#!/usr/bin/env bash
REPO="${1:-sample-repo}"
if [ ! -e "$REPO" ]; then mkdir -p "$REPO"; fi
if [ ! -e "$REPO/.git" ]; then git -C "$REPO" init; fi

function git-make-file {
	echo "$2" > "$REPO/$1"
	git -C "$REPO" add $1
	git -C "$REPO" commit $1 -m "Changed: $1"
}

function git-make-note {
	git -C "$REPO" notes --ref kv add -m "$1"
}

git-make-file "file-a.txt" "A0"
git-make-note "KeyA: ValueA"
git-make-file "file-b.txt" "B0"
git-make-file "file-a.txt" "A1"
git-make-note "KeyB: ValueB"
git-make-file "file-b.txt" "B1"
# EOF
