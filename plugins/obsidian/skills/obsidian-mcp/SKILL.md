---
name: obsidian-mcp
version: "1.6.0"
description: >
  Comprehensive guide and instruction set for AI agents connecting to Obsidian vaults
  via Model Context Protocol (MCP). Use this skill whenever interacting with an Obsidian
  vault through MCP tools (stdio or HTTP/SSE transports), performing multi-vault routing,
  surgically patching notes, querying Obsidian Bases, managing tasks, inspecting outlines,
  analyzing backlinks, or controlling desktop commands and bookmarks.
triggers:
  - "obsidian mcp"
  - "mcp vault"
  - "obsidian_read_note"
  - "obsidian_patch_note"
  - "obsidian_create_note"
  - "obsidian_search"
  - "obsidian_list_vaults"
  - "obsidian_list_tasks"
  - "obsidian_list_bookmarks"
  - "obsidian_outline"
  - "obsidian_word_count"
  - "multi-vault"
  - "vault tools"
---

# Obsidian Model Context Protocol (MCP) Skill

The `obsidian-mcp` server provides standard Model Context Protocol (MCP) tools, resources, and prompts for AI coding agents and assistants. It functions as a secure, zero-cloud transporter bridge between large language models and local Obsidian vaults.

---

## 1. Core Principles

1. **Direct Vault Bridge**: Operations read and write directly to the local filesystem without external storage or proprietary cloud databases.
2. **Multi-Vault Support**: All tools accept an optional `vault` parameter to route operations across multiple configured vaults. If omitted, the default configured vault is used.
3. **Surgical Note Editing**: AI agents should use `obsidian_patch_note` for targeted section and block edits rather than overwriting entire notes with `obsidian_update_note`.
4. **Non-Destructive Deletion**: `obsidian_delete_note` safely moves deleted files into the `.obsidian-mcp/trash/` directory by default, unless `permanent: true` is explicitly requested.
5. **Path Validation**: Path traversal attempts (e.g., `../../`) are strictly blocked by built-in path guards. All paths are vault-relative.

---

## 2. Multi-Vault Routing

When multiple vaults are configured via the `OBSIDIAN_VAULTS` environment variable, agents can query and target specific vaults seamlessly:

```json
// List all accessible vaults
obsidian_list_vaults()

// Target a specific vault in any tool call
obsidian_read_note({ "path": "Projects/Roadmap.md", "vault": "WorkVault" })
obsidian_search({ "query": "quarterly targets", "vault": "WorkVault" })
```

If the `vault` parameter is omitted, the server routes the request to the configured default vault.

---

## 3. Tool Suite Overview (51 Tools)

### A. Vault Discovery & Diagnostics
- `obsidian_list_vaults`: List all registered vaults and their active filesystem paths.
- `obsidian_get_vault`: Retrieve metadata and stats for the active or named vault.

### B. Note Lifecycle & File Operations
- `obsidian_read_note`: Retrieve note markdown content. Supports optional `encoding` (utf-8 / base64).
- `obsidian_create_note`: Create a note. Accepts `content`, optional `template`, and `overwrite` boolean.
- `obsidian_append_note`: Append text cleanly to the end of a note.
- `obsidian_prepend_note`: Prepend text after YAML frontmatter (preserving metadata).
- `obsidian_update_note`: Complete overwrite of a note's content. Use with care.
- `obsidian_patch_note`: **Recommended for edits**. Surgical search-and-replace, regex replacement, or anchored insertions.
- `obsidian_move_note`: Rename or relocate a note within the vault.
- `obsidian_delete_note`: Soft-trash (`permanent: false`, default) or permanent deletion (`permanent: true`).
- `obsidian_get_file_info`: Metadata including file size, created timestamp, modified timestamp, and extension.
- `obsidian_list_files`: Vault directory listing with folder scope, recursive traversal, and extension filtering.

### C. Search & Retrieval
- `obsidian_search`: Full-text vault search with optional `path` scope, `limit`, and `format` (`text` or `json`).
- `obsidian_search_context`: Full-text search returning surrounding context snippets for each match.
- `obsidian_find_notes`: Pattern-based file matching using glob and filename filters.
- `obsidian_recent_changes`: Retrieve recently modified notes within a specified time horizon.

### D. Document Analysis & Metrics
- `obsidian_outline`: Extract note heading hierarchy (`#`, `##`, `###`) with line offsets for structured navigation.
- `obsidian_word_count`: Return word count, character count, and estimated reading time for a document.
- `obsidian_random_note`: Retrieve a random note path or content from the vault or a specified folder.
- `obsidian_get_aliases`: Retrieve configured aliases from note frontmatter.

### E. Daily Notes
- `obsidian_read_daily_note`: Read today's or a date-specified daily note.
- `obsidian_append_daily_note`: Append bullet points or logs to the daily note.
- `obsidian_prepend_daily_note`: Prepend announcements or briefings to the daily note.

### F. Bookmarks
- `obsidian_list_bookmarks`: Read vault bookmarks from `.obsidian/bookmarks.json`.
- `obsidian_create_bookmark`: Add a note, file, or search query to Obsidian bookmarks.

### G. Templates & Unique Notes
- `obsidian_list_templates`: List available note templates in the vault.
- `obsidian_read_template`: Read template content with preview support.
- `obsidian_create_unique_note`: Create a Zettelkasten-style timestamp-prefixed note (`YYYYMMDDHHmmss title.md`).

### H. Properties (Frontmatter)
- `obsidian_get_properties`: Retrieve all parsed YAML frontmatter properties as JSON.
- `obsidian_get_property`: Get a single property value by name.
- `obsidian_set_property`: Set or update a frontmatter key-value pair cleanly.
- `obsidian_remove_property`: Delete a property key from frontmatter.

### I. Task Management
- `obsidian_list_tasks`: Extract markdown tasks (`- [ ]`, `- [x]`) vault-wide or scoped by file/status (`all`, `todo`, `done`).
- `obsidian_toggle_task`: Toggle completion status of a task at a specific line number.

### J. Graph, Links & Tags
- `obsidian_get_backlinks`: Return all notes that link to a target note.
- `obsidian_get_links`: Return all outgoing wikilinks and markdown links from a note.
- `obsidian_get_link_path`: Resolve a wikilink target to its exact vault-relative path.
- `obsidian_get_orphans`: Find notes with zero incoming or outgoing connections.
- `obsidian_get_unresolved_links`: Find broken links pointing to non-existent notes.
- `obsidian_get_deadends`: Find notes with no outgoing links.
- `obsidian_get_tags`: List all `#tags` in the vault with occurrence counts.
- `obsidian_get_tag_notes`: List all notes containing a specific tag.

### K. Obsidian Bases
- `obsidian_list_bases`: Find all `.base` files in the vault.
- `obsidian_query_base`: Query database views, records, and formula fields.
- `obsidian_get_note_context`: Extract contextual properties and related base entries for a note.

### L. Desktop & Developer Controls
- `obsidian_open_in_app`: Open a note or file directly inside the Obsidian desktop application.
- `obsidian_execute_command`: Trigger an Obsidian palette command by ID (e.g., `app:toggle-left-sidebar`).
- `obsidian_list_plugins`: Inspect installed community and core plugins and their enabled status.
- `obsidian_list_snippets`: Inspect installed CSS snippets and their enabled status.

---

## 4. Standard Agent Workflows

### Workflow 1: Inspecting and Surgically Modifying Notes

When tasked with editing an existing note:
1. Call `obsidian_read_note({ "path": "docs/architecture.md" })`.
2. Inspect the structure or call `obsidian_outline({ "path": "docs/architecture.md" })` for complex documents.
3. Call `obsidian_patch_note` with exact `search` and `replace` strings:
   ```json
   {
     "path": "docs/architecture.md",
     "search": "### Planned Migrations\n- Old queue system",
     "replace": "### Planned Migrations\n- Distributed event bus v2 (Completed)\n- Worker pool upgrade"
   }
   ```
4. Verify changes by reading the note or checking backlinks.

### Workflow 2: Researching Across the Vault

When finding information related to a topic:
1. Execute search: `obsidian_search({ "query": "authentication flow", "format": "json" })`.
2. If context is needed: `obsidian_search_context({ "query": "OAuth2 callback" })`.
3. Inspect incoming links to understand note importance: `obsidian_get_backlinks({ "file": "Auth Architecture" })`.
4. Check tags: `obsidian_get_tags()`.

### Workflow 3: Capturing Logs & Daily Tasks

When appending daily progress:
1. Call `obsidian_append_daily_note({ "content": "- [ ] Implement security verification for session tokens" })`.
2. Check existing incomplete tasks: `obsidian_list_tasks({ "status": "todo" })`.
3. Toggle completed tasks: `obsidian_toggle_task({ "path": "Daily Notes/2026-10-05.md", "line": 14 })`.

---

## 5. Security & Permission Guardrails

- **Path Isolation**: Absolute paths (`/etc/passwd`, `C:\Windows`) and parent traversals (`../`) result in immediate errors.
- **Scope Compliance**: If the server is started with `OBSIDIAN_READ_ONLY=true` or scope restrictions (`notes:read`, `search:read`), mutating tools return a structured permission error.
- **Trash Preservation**: Deleting a file moves it to `.obsidian-mcp/trash/<timestamp>-<filename>`. Recoverable at any time.

For full schemas and parameter tables, see [`references/tools-reference.md`](references/tools-reference.md).
For client integration setup, see [`references/mcp-setup.md`](references/mcp-setup.md).
