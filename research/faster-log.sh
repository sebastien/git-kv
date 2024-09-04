#!/usr/bin/env bash
# The fastest way to get all notes is to use the log command. We can filter out commits and just keep the notes using `grep -v HASH=`
GIT_NOTES_REF=refs/notes/kv git -C sample-repo log --pretty=format:"HASH=%h %aI %n%N" --reverse | grep -v 'HASH='

