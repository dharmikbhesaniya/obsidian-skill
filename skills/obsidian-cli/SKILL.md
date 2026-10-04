---
name: obsidian-cli
version: "1.4.0"
description: >
  Use this skill whenever the user wants to interact with their Obsidian vault from the
  command line or have an AI agent perform operations on notes, daily notes, properties,
  tags, tasks, links, bookmarks, templates, sync history, Bases, outlines, word count,
  random notes, unique notes, desktop navigation, or file recovery. Also supports Obsidian
  plugin and theme development with commands to reload plugins, inspect snippets, run
  JavaScript in app context, capture errors, take screenshots, inspect DOM and CSS, and
  toggle mobile emulation. Treat requests implying "go into my vault and do X" as an
  action trigger. Skip for pure conceptual questions about GUI navigation or settings.
triggers:
  - "obsidian"
  - "vault"
  - "daily note"
  - "obsidian cli"
  - "note"
  - "append to"
  - "prepend to"
  - "search my vault"
  - "create a note"
  - "read note"
  - "move note"
  - "rename note"
  - "delete note"
  - "tasks in obsidian"
  - "open tasks"
  - "backlinks"
  - "orphaned notes"
  - "broken links"
  - "frontmatter"
  - "properties"
  - "sync history"
  - "obsidian bases"
  - "file history"
  - "bookmarks"
  - "bookmark"
  - "outline"
  - "aliases"
  - "templates"
  - "template"
  - "word count"
  - "wordcount"
  - "random note"
  - "unique note"
  - "open in obsidian"
  - "open note"
  - "css snippets"
  - "obsidian command"
  - "hotkeys"
  - "reload plugin"
  - "dev:screenshot"
  - "obsidian eval"
---

# Obsidian CLI

The official Obsidian CLI (v1.12+) enables comprehensive control of an Obsidian desktop instance from the command line over IPC. Requires Obsidian desktop to be running.

> For exhaustive documentation on all 130+ commands, parameter tables, and output formats, refer to [`references/command-reference.md`](references/command-reference.md).
>
> For known CLI silent failures, scope traps, and workarounds, refer to [`references/reliability-rules.md`](references/reliability-rules.md).

---

## Prerequisites

| Requirement | Details |
|---|---|
| **Obsidian Desktop** | **v1.12.0+** |
| **CLI enabled** | Settings &rarr; Command line interface &rarr; Toggle **ON** |
| **Obsidian running** | The desktop application **must be running** (communicates over IPC) |

### Platform-Specific Notes

- **macOS / Linux**: The `obsidian` binary is registered in your `PATH` automatically upon enabling CLI in Settings.
- **Windows**: Requires the `Obsidian.com` redirector file placed alongside `Obsidian.exe`. **Must run with normal user privileges** (admin terminals cause silent failures).
  - If colon subcommands (`property:set`, `daily:append`, etc.) return exit `127`, verify `Obsidian.com` exists. If missing, reinstall the latest version from [obsidian.md/download](https://obsidian.md/download).
  - **Git Bash / MSYS2**: If Bash resolves `obsidian` to `Obsidian.exe` instead of `Obsidian.com`, create a wrapper script at `~/bin/obsidian`:
    ```bash
    #!/bin/bash
    /c/path/to/Obsidian.com "$@"
    ```
- **Headless Linux**: Use the `.deb` package (not snap). Run under `xvfb` and prefix commands with `DISPLAY=:5`. Ensure `PrivateTmp=false` in systemd services.

---

## Syntax and Conventions

All parameters use **`key=value`** syntax. Quote values containing spaces.

```bash
obsidian <command> [subcommand] [key=value ...] [flags]
```

### File Targeting

Commands target files using one of two parameter styles (or the active file if omitted):
- `file="<name>"`: Resolves like a wikilink (note name without path or `.md` extension).
- `path="<path>"`: Exact vault-relative path (e.g., `projects/roadmap.md`).

For multiline text content, use `\n` for newlines and `\t` for tabs.

### Vault Targeting

Commands target the most recently active/focused vault by default. To target a specific vault:
- **Flag method**: `obsidian vault="My Vault" <command> ...`
- **Positional method**: `obsidian "My Vault" <command> ...`

---

## Command Overview (130+ Commands)

| Group | Key Commands | Purpose |
|---|---|---|
| **Files** | `read`, `create`, `append`, `prepend`, `move`, `rename`, `delete`, `files`, `folders`, `file`, `random` | Note CRUD and file discovery |
| **Daily Notes** | `daily`, `daily:read`, `daily:append`, `daily:prepend`, `daily:path` | Daily note operations |
| **Search** | `search`, `search:context` | Full-text search (`format=json`, matching line excerpts) |
| **Properties** | `properties`, `property:read`, `property:set`, `property:remove`, `aliases` | Frontmatter metadata management |
| **Tags** | `tags`, `tag` | Tag listing, occurrence counts, and filtering |
| **Tasks** | `tasks`, `task` | Task queries, filtering (`todo`, `done`, `daily`), and toggling |
| **Links** | `backlinks`, `links`, `unresolved`, `orphans`, `deadends` | Vault link and graph analysis |
| **Bookmarks** | `bookmarks`, `bookmark` | List and add bookmarks |
| **Templates** | `templates`, `template:read`, `template:insert` | Template management and insertion |
| **Plugins** | `plugins`, `plugin`, `plugin:enable/disable/install/uninstall/reload`, `plugins:restrict` | Community plugin management |
| **Sync** | `sync`, `sync:status`, `sync:history`, `sync:read`, `sync:restore`, `sync:deleted` | Obsidian Sync operations |
| **Themes** | `themes`, `theme`, `theme:set`, `theme:install`, `theme:uninstall` | Theme management |
| **Snippets** | `snippets`, `snippets:enabled`, `snippet:enable`, `snippet:disable` | CSS snippet management |
| **Commands** | `commands`, `command`, `hotkeys`, `hotkey` | Execute Obsidian commands by ID; inspect hotkeys |
| **Bases** | `bases`, `base:query`, `base:views`, `base:create` | Obsidian Bases querying and creation |
| **History** | `history`, `history:list`, `history:read`, `history:restore` | Local File Recovery snapshot management |
| **Workspace** | `workspace`, `tabs`, `tab:open` | Workspace layout and tab management |
| **Diff** | `diff` | Compare local vs sync file versions |
| **Developer** | `eval`, `dev:screenshot`, `dev:debug`, `dev:console`, `dev:errors`, `dev:css`, `dev:dom`, `dev:mobile`, `devtools` | Debugging, inspection, and test automation |
| **Vault** | `vault`, `vaults`, `version`, `reload`, `restart`, `outline`, `wordcount`, `recents` | App status and control |

---

## Quick Reference — Common Operations

### Reading and Writing Notes

```bash
# Read raw markdown
obsidian read path="folder/note.md"
obsidian read file="Meeting Note"

# Create a note — ALWAYS add 'silent' flag during agent operations
# Without 'silent', create opens the file in Obsidian's UI
obsidian create path="folder/new-note" content="# Title\n\nInitial text." silent
obsidian create path="projects/feature" template="project-template" silent overwrite

# Append and prepend content
obsidian append path="folder/note.md" content="New trailing content"
obsidian prepend path="folder/note.md" content="Content inserted after frontmatter"

# Move, rename, delete
obsidian move path="inbox/idea.md" to="archive/2026/idea.md"
obsidian delete path="scratch/temp.md" permanent
```

### Daily Notes

```bash
obsidian daily                          # Open today's note in UI
obsidian daily:read                     # Print today's note to stdout
obsidian daily:append content="- [ ] Follow up on PR #10"
obsidian daily:prepend content="## Morning Briefing"
```

### Search

```bash
obsidian search query="meeting" limit=10
obsidian search query="refactor" format=json matches     # Preferred: structured JSON with line numbers
obsidian search:context query="TODO"
```

> **Gotcha**: Plain `search query="..."` returns unstructured text. Always use `format=json matches` for programmatic consumption — it returns `[{"file":"path","matches":[{"line":N,"text":"..."}]}]`.

### Properties and Tags

```bash
obsidian properties path="note.md" format=tsv            # Use format=tsv for stable parsing
obsidian property:set path="note.md" name="status" value="in-progress"
obsidian property:read path="note.md" name="status"
obsidian property:remove path="note.md" name="draft"
obsidian tags all counts sort=count                      # MUST use 'all' for vault-wide tags
```

> **Gotcha — properties**: `format=json` on `properties` returns YAML-like output, not valid JSON. Use `format=tsv` for stable key-value parsing.
>
> **Gotcha — tags**: `tags counts` without `all` returns tags for the active file only (often empty). Always use `tags all counts` for vault-wide results.

### Tasks

```bash
obsidian tasks all                      # All vault-wide tasks (todo + done)
obsidian tasks all todo                 # Vault-wide incomplete tasks only
obsidian tasks daily todo               # Incomplete tasks in today's daily note
obsidian task path="note.md" line=12 toggle
```

> **Gotcha — tasks scope**: `tasks` or `tasks todo` without `all` defaults to the active file scope (often nothing is active via CLI), returning **0 results silently**. Always use `tasks all` for vault-wide queries.

### Bookmarks

```bash
obsidian bookmarks                                      # List all saved bookmarks
obsidian bookmark file="folder/note.md"                 # Bookmark a note
obsidian bookmark file="folder/note.md" title="Custom"  # Bookmark with custom title
obsidian bookmark file="folder/note.md" subpath="#H2"   # Bookmark specific heading
obsidian bookmark search="query text" title="Saved"     # Bookmark a search query
```

### Outline & Document Structure

```bash
obsidian outline path="projects/roadmap.md"             # Heading hierarchy
obsidian outline path="projects/roadmap.md" format=json # Structured heading tree with line offsets
```

### Aliases

```bash
obsidian aliases path="notes/concept.md"                # Note aliases from frontmatter
obsidian aliases                                        # Vault-wide alias lookup table
```

### Templates & Dynamic Variables

```bash
obsidian templates                                      # List available template files
obsidian template:read name="meeting-notes"             # Read template raw text
obsidian template:read name="meeting-notes" resolve title="Design Review" # Resolve {{title}}, {{date}}, {{time}}
obsidian create path="meetings/review" template="meeting-notes" silent    # Create note from template
```

> **Gotcha — templates**: `template:insert` inserts into whichever file is currently active in the Obsidian desktop UI window and fails if no note is open. Use `obsidian create path="..." template="..." silent` for robust programmatic creation.

### Word Count & Document Metrics

```bash
obsidian wordcount path="notes/article.md"              # Words, characters, sentences, and reading time
```

### Random & Unique Notes

```bash
obsidian random:read                                    # Read content of random note to stdout
obsidian random:read folder="quotes"                    # Scoped to folder
obsidian random                                         # Open random note in UI
obsidian unique title="Core Concept"                    # Create timestamped Zettelkasten note
```

### Desktop Navigation & Open

```bash
obsidian open path="projects/roadmap.md"                # Focus/open note in Obsidian UI
obsidian open path="projects/roadmap.md" newtab         # Open note in a new tab
```

### Obsidian Commands & Hotkeys

```bash
obsidian commands                                       # List all command IDs
obsidian commands filter="theme"                        # Filter command palette IDs
obsidian command id="app:toggle-left-sidebar"           # Trigger command by ID
obsidian hotkeys                                        # Inspect assigned keybindings
```

### CSS Snippets

```bash
obsidian snippets                                       # List installed CSS snippets
obsidian snippets:enabled                               # List enabled snippets
obsidian snippet:enable name="card-view"                # Enable snippet
obsidian snippet:disable name="card-view"               # Disable snippet
```

### Obsidian Bases

```bash
obsidian bases                                          # List all .base files in vault
obsidian base:query file="tasks" format=json            # Query database records as JSON
obsidian base:query path="data/tasks.base" view="Table" # Query specific view
obsidian base:views file="tasks"                        # List views defined in base
```

### File Recovery & History Snapshots

```bash
obsidian history:list                                   # List files with local snapshots
obsidian history path="notes/draft.md"                  # List snapshot timestamps
obsidian history:read path="notes/draft.md" version=2   # Read previous snapshot
obsidian history:restore path="notes/draft.md" version=2 # Restore snapshot version
```

### Obsidian Sync

```bash
obsidian sync:status                                    # Current sync engine state
obsidian sync:history path="notes/draft.md"             # Remote version history
obsidian sync:deleted                                   # List files deleted via sync
```

---

## Plugin and Theme Development Workflow

Follow this cycle when developing Obsidian plugins and themes:

1. **Reload changes**:
   ```bash
   obsidian plugin:reload id="my-plugin-id"
   ```
2. **Check for runtime errors**:
   ```bash
   obsidian dev:errors
   ```
3. **Inspect DOM and CSS**:
   ```bash
   obsidian dev:dom selector=".workspace-leaf" text
   obsidian dev:css selector=".workspace-leaf" prop=background-color
   ```
4. **Capture visual screenshot**:
   ```bash
   obsidian dev:screenshot path="tests/screenshot.png"
   ```
5. **Inspect console output**:
   ```bash
   obsidian dev:debug on
   obsidian dev:console level=error limit=20
   ```
6. **Execute JavaScript in app context**:
   ```bash
   obsidian eval code="app.vault.getMarkdownFiles().length"
   ```
7. **Toggle mobile emulation**:
   ```bash
   obsidian dev:mobile on
   ```

---

## TUI Mode

Running `obsidian` with no arguments opens an interactive terminal interface:

| Key | Action |
|---|---|
| `↑` / `↓` | Navigate file list |
| `Enter` | Open file in Obsidian |
| `/` | Search vault |
| `n` | Create new note |
| `d` | Delete note |
| `r` | Rename note |
| `q` | Exit TUI |

---

## Safety Policy for Vault Operations

Follow the **Read &rarr; Verify &rarr; Execute &rarr; Confirm** pattern for all operations that modify vault state.

### Non-Destructive Operations (Read, Search, List)
Execute directly. No confirmation needed.

### Additive Operations (Create, Append, Prepend)
1. **Verify target**: Confirm the file path or daily note exists (or should be created).
2. **Execute**: Run the command.
3. **Confirm**: Read the file back or check for errors.

### Destructive Operations (Delete, Move, Rename, Overwrite)
1. **Identify**: Search for the exact file to verify it exists and confirm the path.
2. **Inspect**: Check incoming backlinks (`obsidian backlinks`) to understand impact.
3. **Confirm intent**: Only use `permanent` deletion when the user explicitly requests it. Default to trash.
4. **Execute**: Run the command.
5. **Verify**: Confirm the operation completed (e.g., file no longer at original path, file exists at new path).

```bash
# Example: Safe delete workflow
obsidian file path="scratch/temp.md"         # 1. Verify file exists
obsidian backlinks file="scratch/temp.md"    # 2. Check incoming links
obsidian delete path="scratch/temp.md"       # 3. Execute (trash, not permanent)
obsidian file path="scratch/temp.md"         # 4. Confirm removal
```

### Property Modification
1. **Read current value**: `obsidian property:read path="note.md" name="status"`
2. **Set new value**: `obsidian property:set path="note.md" name="status" value="done"`
3. **Verify**: `obsidian property:read path="note.md" name="status"`

---

## Important Rules and Tips

1. **Vault-Relative Paths**: Always specify paths relative to vault root (`folder/note.md`), never absolute OS paths.
2. **`create` vs `move` extension behavior**:
   - `create path="folder/note"` omits `.md` (appended automatically).
   - `move path="old.md" to="new.md"` requires the full destination path with `.md`.
3. **`template:insert` constraint**: Only inserts into the currently open file in the GUI. To create a new file headlessly from a template, use `obsidian create path="path/name" template="template-name"`.
4. **`property:set` lists**: `value="a, b"` stores a string. To store native YAML array lists, modify the note's frontmatter directly or use `obsidian eval`.
5. **Multiline `eval`**: Inline multiline JS may cause parsing errors. For multiline logic, write to a script file and pass its content:
   ```bash
   obsidian eval code="$(cat script.js)"
   ```
6. **Pipe-friendly**: Combine commands cleanly with Unix tools (`grep`, `jq`, `sed`, `awk`).

---

## Troubleshooting Guide

| Problem | Root Cause | Solution |
|---|---|---|
| Empty output / command hangs | Obsidian is closed, or run from an Admin terminal on Windows | Ensure Obsidian is open; run from a standard-privilege terminal |
| `command not found: obsidian` | CLI path not registered in shell environment | Toggle CLI OFF then ON in Obsidian Settings; restart terminal |
| Exit code `127` on colon commands | Missing `Obsidian.com` or Git Bash resolving `.exe` | Reinstall Obsidian v1.12+; on Git Bash, use an `Obsidian.com` wrapper script |
| Socket error / IPC failure on Linux | Systemd service isolation (`PrivateTmp=true`) or Snap | Set `PrivateTmp=false` in systemd unit; install official `.deb` package |
| Headless Linux display error | No X server running | Run under `xvfb-run` or export `DISPLAY=:5` |
| `Command "[Vault Name]" not found` | Shell argument parsing variation | Use `vault="[Vault Name]"` flag or switch to the vault in GUI |
| Error message but `$?` = 0 | CLI returns exit code 0 even on some failures | **Never rely solely on exit codes.** Always parse stdout for `Error:` prefixes to detect actual failures |
| Tags/tasks return empty | Scope defaults to active file (nothing active in CLI mode) | Always use `tags all` and `tasks all` for vault-wide operations |

### Fallback Strategy

If the Obsidian CLI is unavailable (app not running, CLI not installed, or version too old), fall back to direct file system tools (Read, Write, Edit, Grep, Glob) for basic operations. The CLI is required only when Obsidian's index or app features add value (search, backlinks, tags, tasks, properties, bases). Plain text manipulation can always use file tools directly.

Run `obsidian vault` to confirm CLI connectivity — it returns the vault name, path, and file count when working correctly.

