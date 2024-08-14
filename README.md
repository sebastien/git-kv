## Git Kv: A Key-Value Store for Your Git Repository

`git-kv` is a Bash script that adds a simple key-value store on top of your Git
repository. It uses Git notes to store and manage key-value pairs associated
with specific commits.

Here are some examples of how it can be used

```bash
# Keep track of a the identifier of a build artifact
git kv set container.id  myapp-634c747b8893e56be998636fc65a0f58edc22a7b

# Store the expected signature of an expected build output
git kv set dist.archive.sha256 014d6fc1f46075435d8100bace0deaf806f455326c941bf7ed2553e553287de1

# Record the approval of a given revision
git kv set approval 7286057eb65859b27ad5cb2f22043880a6bd0e19
```

`git-kv` is implemented as a Bash script and relies on standard Git commands
and common CLI tooks. Also not that:
- Data is stored in `git notes` (see `.git/refs/notes`), which are fetched
  separately from the main repository content. Use `git kv pull` to fetch the
  latest key-value data.
- Key deletions are also tracked as entries in Git notes.

## Installation

To install using `curl` and `make`, run:

```bash
curl -s https://raw.githubusercontent.com/sebastien/git-kv/master/Makefile | make -f /dev/stdin install
```

## Usage

`git-kv` provides the following subcommands:

### `show`

Display key-value pairs associated with a given commit.

```sh
git kv show [COMMIT]
```

- `COMMIT`: (Optional) The commit to display key-value pairs for. Defaults to the currently checked-out commit.
- Output format can be controlled using the `-tjson` option for JSON output.

### `del/delete`

Delete a key for a given commit.


```sh
git kv del|delete KEY [COMMIT]
```

- `KEY`: The key to delete.
- `COMMIT`: (Optional) The commit to delete the key from. Defaults to the currently checked-out commit.

### `set`

Set a key-value pair for a given commit.

```sh
git kv set KEY VALUE [COMMIT]
```

- `KEY`: The key to set.
- `VALUE`: The value to associate with the key.
- `COMMIT`: (Optional) The commit to set the key-value pair for. Defaults to the currently checked-out commit.

### `get`

Get the latest value for a key.

```sh
git kv get KEY [COMMIT]
```

- `KEY`: The key to get the value for.
- `COMMIT`: (Optional) The commit to start searching from. Defaults to the currently checked-out commit.

### `get-all`

Get all values for a key since the given commit.

```sh
git kv get-all KEY [COMMIT]
```

- `KEY`: The key to get all values for.
- `COMMIT`: (Optional) The commit to start searching from. Defaults to the currently checked-out commit.

### `list`

List all keys matching a pattern for a given commit.

```sh
git kv list KEYISH [COMMIT]
```

- `KEYISH`: A pattern to match keys against.
- `COMMIT`: (Optional) The commit to list keys for. Defaults to the currently checked-out commit.

### `list-all`

List all keys matching a pattern, including deleted keys.

```sh
git kv list-all KEYISH [COMMIT]
```

- `KEYISH`: A pattern to match keys against.
- `COMMIT`: (Optional) The commit to list keys for. Defaults to the currently checked-out commit.

### `push`

Push key-value data to a remote repository.


```sh
git kv push [ORIGIN]
```

- `ORIGIN`: (Optional) The remote repository to push to. Defaults to the default remote.

### `pull`

Pull key-value data from a remote repository.

```sh
git kv pull [ORIGIN]
```

- `ORIGIN`: (Optional) The remote repository to pull from. Defaults to the default remote.


