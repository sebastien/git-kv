```
          _ __     __
   ____ _(_) /_   / /___   __
  / __ `/ / __/  / //_/ | / /
 / /_/ / / /_   / ,<  | |/ /
 \__, /_/\__/  /_/|_| |___/
/____/
```

## Git-KV
### A Key-Value Store for Your Git Repository

`git-kv` is a Bash script that adds a lightweight key-value store on top of your Git repository. It uses Git notes to store and manage key-value pairs associated with commits.

Examples:

```bash
# Keep track of the identifier of a build artifact
git kv set container.id myapp-634c747b8893e56be998636fc65a0f58edc22a7b

# Store the expected signature of a build output
git kv set dist.archive.sha256 014d6fc1f46075435d8100bace0deaf806f455326c941bf7ed2553e553287de1

# Record the approval commit for a revision
git kv set approval 7286057eb65859b27ad5cb2f22043880a6bd0e19

# Record the time to run your test suite on a given machine
git kv set performance.host-1234 12.23
```

Notes:
- Data is stored in `git notes` under `refs/notes/kv` (see `.git/refs/notes`).
- Notes are fetched separately from regular Git refs; use `git kv pull` to sync key-value data.
- Deletions are represented as tombstones (`key:` with an empty value) and are also tracked in notes history.
- `get` and `list` hide tombstones; use `list-all` or `show` to inspect deletion history.

## Prerequisites

- `git`
- `bash`
- Common CLI tools used by the script: `awk`, `grep`, `cut`, `sort`, `uniq`

## Installation

Install with `curl | sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/sebastien/git-kv/main/install.sh | sh
```

Install from a local clone:

```bash
make install
```

Or download the script directly:

```bash
curl -fsSL https://raw.githubusercontent.com/sebastien/git-kv/main/bin/git-kv -o git-kv
chmod +x git-kv
```

## Quick Start

```bash
# Set and read values on current commit (HEAD)
git kv set build.id 123
git kv get build.id
git kv show

# Sync notes with remote
git kv push
git kv pull
```

## Usage

```sh
git kv <subcommand> [options]
```

Run `git kv help` or `git kv --help` to list all subcommands.
Run `git kv --version` to print the current version string.

Defaults:
- `COMMIT` defaults to `HEAD`.
- `ORIGIN` defaults to `origin`.

### `show`

Display key-value pairs associated with a commit.

```sh
git kv show [COMMIT] [-tjson] [-traw]
```

- `-tjson`: output key/value pairs as JSON.
- `-traw`: output raw note history format (includes commit markers and dates).

### `del` / `delete`

Delete a key for a commit.

```sh
git kv del KEY [COMMIT]
git kv delete KEY [COMMIT]
```

### `set`

Set a key-value pair for a commit.

```sh
git kv set [-f|--force] KEY VALUE [COMMIT]
```

By default, `set` is a no-op when the key already has the same value. Use `-f` or `--force` to rewrite the note anyway.

### `get`

Get the latest value for keys matching `KEY` using shell glob matching.

```sh
git kv get KEY [COMMIT]
```

### `get-all`

Get all matching values for keys since the given commit.

```sh
git kv get-all KEY [COMMIT]
```

### `def`

Show which commit defines matching keys.

```sh
git kv def KEY [COMMIT]
```

### `list`

List keys matching `KEYISH` for a commit.

```sh
git kv list KEYISH [COMMIT]
```

### `list-all`

List all keys matching `KEYISH`, including deleted keys.

```sh
git kv list-all KEYISH [COMMIT]
```

### `items`

Output matching key/value pairs, one per line.

```sh
git kv items [KEYISH] [COMMIT]
```

### `push`

Push key-value notes to a remote.

```sh
git kv push [ORIGIN]
```

### `pull`

Fetch key-value notes from a remote.

```sh
git kv pull [ORIGIN]
```

## Pattern Matching Notes

- `KEY` and `KEYISH` arguments are treated as shell globs in `get`, `get-all`, `list`, `list-all`, `items`, and `def`.
- Quote patterns like `'*storage*'` so your shell does not expand them before `git kv` sees them.
- If you need an exact match, pass the literal key without glob metacharacters.
