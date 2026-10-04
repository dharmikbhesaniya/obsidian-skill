---
name: obsidian-mcp
version: "1.0.0"
description: >
  Operational guide for AI agents interacting with Obsidian vaults via Model Context
  Protocol (MCP) tools. Covers vault inventory, safe note authoring, surgical section/block/search
  patching, frontmatter properties, task toggling, graph backlinks, database Bases, daily notes,
  word count, outline structures, bookmarks, templates, and multi-vault isolation.
  NOTE: Works exclusively with the companion MCP server: https://github.com/dharmikbhesaniya/obsidian-mcp.
triggers:
  - "obsidian mcp"
  - "mcp obsidian"
  - "obsidian_list_vaults"
  - "obsidian_read_note"
  - "obsidian_create_note"
  - "obsidian_patch_note"
  - "obsidian_update_note"
  - "obsidian_delete_note"
  - "obsidian_search"
  - "obsidian_get_note_context"
  - "obsidian_read_daily_note"
  - "obsidian_append_daily_note"
  - "obsidian_prepend_daily_note"
  - "obsidian_get_properties"
  - "obsidian_set_property"
  - "obsidian_list_tasks"
  - "obsidian_toggle_task"
  - "obsidian_get_backlinks"
  - "obsidian_get_links"
  - "obsidian_list_bases"
  - "obsidian_query_base"
  - "obsidian_outline"
  - "obsidian_word_count"
  - "obsidian_list_bookmarks"
  - "obsidian_create_bookmark"
  - "obsidian_list_templates"
  - "obsidian_create_unique_note"
  - "obsidian_open_note"
  - "obsidian_list_plugins"
  - "obsidian_list_commands"
  - "obsidian_execute_command"
---

# Obsidian Model Context Protocol (MCP) Skill

This skill guides AI assistants and autonomous coding agents in using strongly typed MCP tools to interact with local Obsidian vaults safely and precisely.

> **Compatibility Notice**: This skill works strictly with the companion MCP server repository: [dharmikbhesaniya/obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp). The server exposes 54 semantic tools, optimistic concurrency locking, atomic filesystem guards, and native Obsidian CLI integration. Ensure the companion MCP server is installed and running in your agent environment.

---

## 1. Core Operating Principles

1. **Path Safety**: Always use relative paths from the vault root (e.g. `Projects/Alpha.md`). Never provide absolute filesystem paths or directory traversal patterns (`../`). The MCP server rejects paths escaping the vault root with `403 Forbidden` (`PATH_INVALID`).
2. **Revision Locking**: For non-idempotent modifications (`update`, `patch`, `delete`, `move`, `property_set`), pass `expectedRevision` or `ifMatch` obtained from previous `readNote` calls to prevent clobbering simultaneous user edits (`409 Conflict`).
3. **Prefer Surgical Patching over Full Rewrites**: When updating sections, checklists, or blocks, call `obsidian_patch_note` rather than reading and overwriting the entire file with `obsidian_update_note`.
4. **Multi-Vault Targeting**: When multiple vaults are configured, pass `vault: "<VaultName>"` in tool arguments. Omit `vault` to use the primary default vault.

---

## 2. Tool Reference & Execution Guide

### 2.1 Vault Discovery & Exploration

- `obsidian_list_vaults`:
  Lists all configured vaults, canonical file paths, total file counts, and identifies the active default vault.
  ```json
  {}
  ```

- `obsidian_get_vault`:
  Returns vault root path, reachability of the Obsidian desktop application, and connection health.
  ```json
  { "vault": "Professional" }
  ```

- `obsidian_list_files`:
  Lists files and folders within a vault directory. Supports recursive traversal and extension filtering.
  ```json
  { "folder": "Projects", "recursive": true, "extension": "md" }
  ```

- `obsidian_get_file_info`:
  Returns file size, modification timestamp (`mtime`), and metadata.
  ```json
  { "path": "Daily/2026-10-05.md" }
  ```

---

### 2.2 Note Creation & Lifecycle Management

- `obsidian_create_note`:
  Creates a note. Set `overwrite: false` to ensure existing notes are not accidentally replaced.
  ```json
  {
    "path": "Research/AI Architecture.md",
    "content": "# AI Architecture\n\nStructured system documentation.",
    "overwrite": false
  }
  ```

- `obsidian_create_unique_note`:
  Creates a timestamped, collision-safe unique note (`YYYYMMDDHHmmss-<randomHex> Title.md`). Ideal for fleeting thoughts, zettelkasten, or automated logs.
  ```json
  {
    "title": "Meeting Notes",
    "content": "# Meeting Notes\nDiscussion on data flow.",
    "folder": "Fleeting"
  }
  ```

- `obsidian_read_note`:
  Reads full file content, parsed YAML frontmatter, and current SHA-1 `revision` hash. Set `stripComments: true` to strip internal `%% comments %%`.
  ```json
  { "path": "Projects/Alpha.md", "stripComments": false }
  ```

- `obsidian_update_note`:
  Completely replaces note contents. Always supply `expectedRevision` to avoid race conditions.
  ```json
  {
    "path": "Projects/Alpha.md",
    "content": "# Alpha Updated\nNew content body.",
    "expectedRevision": "f235d90d90b5144f6a51954cce12cc479d3a784b"
  }
  ```

- `obsidian_append_note` / `obsidian_prepend_note`:
  Appends or prepends content to a note with newline preservation.
  ```json
  {
    "path": "Projects/Alpha.md",
    "content": "\n- New milestone achieved."
  }
  ```

- `obsidian_move_note`:
  Moves or renames a note. Automatically rewrites inbound wikilinks (`[[Alpha]]` -> `[[Beta]]`) across all other notes in the vault when `updateBacklinks: true`.
  ```json
  {
    "sourcePath": "Drafts/Spec.md",
    "targetPath": "Archived/Spec.md",
    "updateBacklinks": true
  }
  ```

- `obsidian_delete_note`:
  Safely deletes a note. Defaults to atomic trash (`.obsidian-mcp/trash`) for non-destructive recovery. Set `permanent: true` only when permanent removal is explicitly intended.
  ```json
  { "path": "Drafts/Scratch.md", "permanent": false }
  ```

---

### 2.3 Surgical Patching (`obsidian_patch_note`)

The companion MCP server provides surgical patching to edit specific parts of notes without rewriting entire documents.

#### Mode A: Direct Search and Replace
```json
{
  "path": "Projects/Alpha.md",
  "search": "Status: In Progress",
  "replace": "Status: Completed"
}
```

#### Mode B: Heading Section Targeting
Replaces, appends to, or prepends to an entire markdown heading section:
```json
{
  "path": "Projects/Alpha.md",
  "target": { "type": "heading", "value": "Next Steps" },
  "operation": "append",
  "content": "- [ ] Review deployment logs."
}
```

#### Mode C: Block ID Targeting
Targets a specific markdown block ID (`^block-id`):
```json
{
  "path": "Projects/Alpha.md",
  "target": { "type": "block", "value": "summary-metric" },
  "operation": "replace",
  "content": "Overall uptime: 99.98% ^summary-metric"
}
```

#### Mode D: Regex Pattern Matching
```json
{
  "path": "Projects/Alpha.md",
  "target": { "type": "regex", "value": "Version: \\d+\\.\\d+\\.\\d+" },
  "operation": "replace",
  "content": "Version: 1.2.0"
}
```

---

### 2.4 Daily Notes Workflow

Daily notes automatically resolve against the vault's Daily Notes settings (`folder` and `dateFormat`):

- `obsidian_read_daily_note`: Reads today's or a specific date's daily note.
  ```json
  { "date": "2026-10-05" }
  ```
- `obsidian_append_daily_note`: Appends to a daily note, automatically creating the note if it does not exist yet.
  ```json
  { "content": "- [ ] Finalize system review." }
  ```
- `obsidian_prepend_daily_note`: Prepends to the daily note below frontmatter.
  ```json
  { "content": "## Urgent Notification" }
  ```

---

### 2.5 Frontmatter & Properties Management

Directly manipulates YAML frontmatter without parsing errors:

- `obsidian_get_properties`: Returns all properties as a typed JSON object.
  ```json
  { "path": "Projects/Alpha.md" }
  ```
- `obsidian_get_property`: Retrieves a specific key value.
  ```json
  { "path": "Projects/Alpha.md", "name": "status" }
  ```
- `obsidian_set_property`: Sets or updates a property value (string, array, boolean, number, object).
  ```json
  { "path": "Projects/Alpha.md", "name": "tags", "value": ["project", "enterprise"] }
  ```
- `obsidian_remove_property`: Deletes a property key.
  ```json
  { "path": "Projects/Alpha.md", "name": "draft" }
  ```

---

### 2.6 Task Tracking & Checklists

- `obsidian_list_tasks`:
  Lists all tasks (`- [ ]` and `- [x]`) across the entire vault or a specific note.
  ```json
  { "status": "todo" }
  ```

- `obsidian_toggle_task`:
  Toggles a task between checked and unchecked at an exact line number. Supports `expectedText` to ensure the targeted line has not shifted.
  ```json
  {
    "path": "Daily/2026-10-05.md",
    "line": 14,
    "expectedText": "- [ ] Review deployment logs."
  }
  ```

---

### 2.7 Graph, Links & Analytics

- `obsidian_get_backlinks`: Lists all incoming wikilinks referencing a note.
- `obsidian_get_links`: Lists all outgoing wikilinks from a note.
- `obsidian_get_orphans`: Identifies notes with zero incoming backlinks.
- `obsidian_get_unresolved_links`: Identifies links pointing to non-existent notes.
- `obsidian_get_deadends`: Identifies notes with no outgoing links.
- `obsidian_get_note_context`: Assembles a structured context pack containing the note body, frontmatter, outline headings, backlinks, and related notes.
  ```json
  {
    "path": "Projects/Alpha.md",
    "includeHeadings": true,
    "includeBacklinks": true,
    "maxBacklinkLines": 3
  }
  ```

---

### 2.8 Obsidian Bases (Database Views)

Integrates with Obsidian Bases (`.base` files):
- `obsidian_list_bases`: Discovers all `.base` files in the vault.
- `obsidian_query_base`: Executes structured filters and view definitions against an Obsidian Base.
  ```json
  { "basePath": "Projects.base" }
  ```

---

### 2.9 Structural Outline & Metrics

- `obsidian_outline` (or `obsidian_get_outline`):
  Extracts hierarchical heading tree with line numbers and heading depths (`#`, `##`, `###`).
  ```json
  { "path": "Manual.md" }
  ```

- `obsidian_word_count`:
  Calculates word count, character count, sentence count, paragraph count, and estimated reading time.
  ```json
  { "path": "Manual.md" }
  ```

---

### 2.10 Bookmarks, Templates, Plugins & Commands

- `obsidian_list_bookmarks` / `obsidian_create_bookmark`:
  Inspects or adds items to Obsidian bookmarks.
- `obsidian_list_templates` / `obsidian_read_template`:
  Discovers and reads templates configured in the vault.
- `obsidian_list_aliases` / `obsidian_get_aliases`:
  Retrieves alternate titles configured for notes in frontmatter.
- `obsidian_random_note`:
  Retrieves a random note from the vault or a specified folder.
- `obsidian_open_note`:
  Requests the running Obsidian desktop application to focus and open a note. Returns `{ opened: true }` if desktop CLI is active, or provides the desktop `obsidianUri` fallback.
- `obsidian_list_plugins`:
  Reports active core plugins and installed community plugins (`community-plugins.json`).
- `obsidian_list_snippets`:
  Inspects installed custom CSS snippets.
- `obsidian_list_commands` / `obsidian_execute_command`:
  Inspects and triggers official Obsidian palette commands (e.g. `app:open-settings`).

---

## 3. Recommended Operational Workflows

### Scenario 1: Updating a Note's Status
1. Call `obsidian_read_note` with `{ path: "Projects/Alpha.md" }`.
2. Inspect the returned frontmatter and `revision` hash.
3. Call `obsidian_patch_note` with `{ path: "Projects/Alpha.md", search: "status: backlog", replace: "status: in-progress", expectedRevision: revision }`.

### Scenario 2: Appending a Daily Log
1. Call `obsidian_append_daily_note` with `{ content: "- [ ] 14:00 Sync with product team." }`.
2. The MCP server ensures today's note exists and appends the line cleanly.

### Scenario 3: Investigating Unlinked Notes
1. Call `obsidian_get_orphans` to discover notes without backlinks.
2. For each relevant orphan, call `obsidian_outline` to evaluate structure.
3. Link related notes using `obsidian_patch_note` to improve knowledge graph connectivity.
