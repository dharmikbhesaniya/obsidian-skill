# Obsidian CLI — Reliability Rules

Known silent failures and behavioral quirks in Obsidian CLI v1.12.x. These are tested and verified traps where commands return exit code `0` but produce incorrect, empty, or misleading output.

---

## Scope Defaults

Commands that accept a scope default to the **active file** in the Obsidian UI. When no file is active (common during CLI/agent usage), results are silently empty.

| Command | Naive (Wrong) | Correct | Why |
|---|---|---|---|
| List all tags | `obsidian tags counts` | `obsidian tags all counts` | Without `all`, scopes to active file → empty |
| List all tasks | `obsidian tasks todo` | `obsidian tasks all todo` | Without `all`, scopes to active file → 0 results |
| List properties | `obsidian properties path="note.md"` | `obsidian properties path="note.md" format=tsv` | Default output is ambiguous; `format=tsv` gives stable parsing |

**Rule**: Always use explicit `all` scope for vault-wide tag and task queries.

---

## Output Format Traps

| Command | Naive (Wrong) | Correct | Why |
|---|---|---|---|
| Properties as JSON | `properties format=json` | `properties format=tsv` | `format=json` returns YAML-like output, not valid JSON |
| Search results | `search query="x"` | `search query="x" format=json matches` | Default returns plain text file list; `format=json matches` returns structured `[{"file":"...","matches":[{"line":N,"text":"..."}]}]` |

**Rule**: Use `format=tsv` for properties. Use `format=json matches` for search.

---

## Exit Code Masking

The CLI returns exit code `0` even when the command fails with an error message in stdout.

```bash
# This returns exit code 0 but stdout contains "Error: ..."
obsidian base:views
echo $?  # prints 0
```

**Rule**: Never rely solely on `$?` for error detection. Always parse stdout for lines starting with `Error:`.

```bash
output=$(obsidian base:views 2>&1)
if echo "$output" | grep -q "^Error:"; then
  echo "Command failed: $output"
fi
```

---

## Create Command Gotchas

| Gotcha | Naive (Wrong) | Correct | Why |
|---|---|---|---|
| Opens UI | `create path="note" content="text"` | `create path="note" content="text" silent` | Without `silent`, Obsidian opens the file in its UI |
| Directory creation | `create path="new-folder/note"` | `mkdir -p vault/new-folder && create path="new-folder/note" silent` | CLI does not auto-create parent directories |
| Template placement | `create path="inbox/note" template="tpl"` | Verify actual path after creation | Template settings may override the `path=` and place the file in the template's configured folder |
| Overwrite protection | `create path="existing-note"` | `create path="existing-note" overwrite silent` | Without `overwrite`, create refuses to replace existing files (safe default) |

---

## Multi-Vault Ambiguity

| Gotcha | Naive | Correct | Why |
|---|---|---|---|
| Positional vault name | `obsidian "My Vault" search query="x"` | `obsidian vault="My Vault" search query="x"` | Positional syntax fails on some platforms/shells → `Error: Command "My Vault" not found` |
| No vault specified | `obsidian search query="x"` | Same, if only one vault | Defaults to the most recently focused vault — unreliable in multi-vault setups |

---

## Platform-Specific Failures

| Platform | Gotcha | Fix |
|---|---|---|
| **Windows (Admin terminal)** | Commands hang or produce empty output silently | Run from a standard-privilege (non-Admin) terminal |
| **Windows (Git Bash)** | Exit 127 on colon commands (`daily:append`, `property:set`) | Bash resolves `obsidian` to `.exe` not `.com`. Create a wrapper script at `~/bin/obsidian` pointing to `Obsidian.com` |
| **Linux (Snap)** | IPC socket not found | Snap restricts IPC. Use the official `.deb` package instead |
| **Linux (systemd)** | IPC socket not found | Set `PrivateTmp=false` in the systemd service unit |
| **Linux (headless)** | Display error | Run under `xvfb-run` or `DISPLAY=:5` |

---

## Diagnostic Commands

Run these to verify CLI is functioning:

```bash
obsidian vault      # Returns vault name, path, file count — confirms IPC works
obsidian version    # Shows CLI and installer version
obsidian help       # Lists all available commands for current version
```

If `obsidian vault` fails or hangs, the CLI is not connected to a running Obsidian instance.

---

## Summary of Rules

1. Always use `tasks all` and `tags all` for vault-wide operations.
2. Use `format=tsv` for properties, `format=json matches` for search.
3. Always add `silent` flag to `create` during agent operations.
4. Parse stdout for `Error:` — never trust exit codes alone.
5. Prefer `vault="Name"` over positional `"Name"` for multi-vault targeting.
6. Run `obsidian vault` first to confirm CLI connectivity before running commands.
7. Fall back to direct file tools (Read/Write/Grep) when CLI is unavailable.
8. Use `create path="..." template="..." silent` instead of `template:insert` (which requires an active open tab in the UI).
9. Use `read` for file inspection; `open` only switches desktop UI focus.
10. Ensure the Bookmarks core plugin is enabled before querying `bookmarks`.
