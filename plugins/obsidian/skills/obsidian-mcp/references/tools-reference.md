# Obsidian MCP Tool Reference

Comprehensive reference for all 51 tools exposed by `obsidian-mcp`.

Every tool accepts an optional `vault?: string` parameter to route the call to a specific vault when multiple vaults are configured.

---

## 1. Vault Management

### `obsidian_list_vaults`
List all registered vaults and their active filesystem paths.
- **Parameters**: None
- **Returns**: Array of `{ name: string, path: string, isDefault: boolean }`

### `obsidian_get_vault`
Retrieve metadata and stats for the active or named vault.
- **Parameters**:
  - `vault` *(optional, string)*: Vault name.
- **Returns**: `{ name: string, path: string, totalFiles: number, totalMarkdownFiles: number }`

---

## 2. Note Operations

### `obsidian_read_note`
Read the markdown content of a note.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path (e.g. `docs/intro.md` or `intro.md`).
  - `encoding` *(optional, string, enum: ["utf-8", "base64"])*: Encoding format. Default: `utf-8`.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_create_note`
Create a new note in the vault.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path for the note (e.g. `Projects/Alpha.md`).
  - `content` *(optional, string)*: Initial markdown content.
  - `template` *(optional, string)*: Name or path of a template to instantiate.
  - `overwrite` *(optional, boolean)*: Overwrite existing note if it already exists. Default: `false`.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_append_note`
Append text cleanly to the end of a note.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path to the note.
  - `content` *(required, string)*: Content to append.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_prepend_note`
Prepend text after YAML frontmatter (preserving metadata).
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path to the note.
  - `content` *(required, string)*: Content to prepend after frontmatter.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_update_note`
Completely overwrite an existing note's content.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path to the note.
  - `content` *(required, string)*: Full new markdown content.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_patch_note`
Surgically edit parts of a note without rewriting the entire document.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path to the note.
  - `search` *(optional, string)*: Exact string snippet to locate.
  - `replace` *(optional, string)*: Replacement string.
  - `regex` *(optional, string)*: Regular expression pattern to search for.
  - `append` *(optional, string)*: Content to append if search/regex is omitted.
  - `prepend` *(optional, string)*: Content to prepend if search/regex is omitted.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_move_note`
Move or rename a note within the vault.
- **Parameters**:
  - `path` *(required, string)*: Current vault-relative path.
  - `to` *(required, string)*: Destination vault-relative path.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_delete_note`
Delete a note from the vault.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path.
  - `permanent` *(optional, boolean)*: If true, permanently delete. If false (default), move to `.obsidian-mcp/trash/`.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_file_info`
Retrieve file metadata.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path.
  - `vault` *(optional, string)*: Target vault.
- **Returns**: `{ path, size, created, modified, extension, isDirectory }`

### `obsidian_list_files`
List files and folders in the vault.
- **Parameters**:
  - `folder` *(optional, string)*: Folder scope (e.g. `Projects`). Default: vault root.
  - `recursive` *(optional, boolean)*: Traverse subdirectories. Default: `true`.
  - `extension` *(optional, string)*: Filter by extension (e.g. `md`, `canvas`, `base`).
  - `vault` *(optional, string)*: Target vault.

---

## 3. Search & Discovery

### `obsidian_search`
Full-text vault search.
- **Parameters**:
  - `query` *(required, string)*: Search keyword or phrase.
  - `path` *(optional, string)*: Folder scope restriction.
  - `limit` *(optional, integer)*: Maximum results. Default: 50.
  - `format` *(optional, string, enum: ["text", "json"])*: Output format. Default: `text`.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_search_context`
Full-text search returning lines before and after matches for context.
- **Parameters**:
  - `query` *(required, string)*: Search keyword or phrase.
  - `contextLines` *(optional, integer)*: Number of surrounding lines. Default: 2.
  - `limit` *(optional, integer)*: Maximum matches.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_find_notes`
Find notes using filename or glob pattern matching.
- **Parameters**:
  - `pattern` *(required, string)*: Search pattern (e.g. `*meeting*` or `review`).
  - `vault` *(optional, string)*: Target vault.

### `obsidian_recent_changes`
List recently modified notes in the vault.
- **Parameters**:
  - `limit` *(optional, integer)*: Maximum notes to return. Default: 20.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_outline` / `obsidian_get_outline`
Extract heading hierarchy for a note.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note path.
  - `vault` *(optional, string)*: Target vault.
- **Returns**: Array of `{ level: number, heading: string, line: number }`

### `obsidian_word_count`
Document metrics and reading time estimates.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note path.
  - `vault` *(optional, string)*: Target vault.
- **Returns**: `{ words: number, characters: number, readingMinutes: number }`

### `obsidian_random_note`
Select a random note from the vault.
- **Parameters**:
  - `folder` *(optional, string)*: Subfolder scope.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_aliases` / `obsidian_list_aliases`
Extract configured aliases from note frontmatter or vault-wide.
- **Parameters**:
  - `path` *(optional, string)*: Vault-relative note path (if omitted, lists vault-wide alias index).
  - `vault` *(optional, string)*: Target vault.

---

## 4. Daily Notes

### `obsidian_read_daily_note`
Read today's daily note or a note for a specific date.
- **Parameters**:
  - `date` *(optional, string)*: Date in `YYYY-MM-DD` format. Default: today.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_append_daily_note`
Append text to today's daily note.
- **Parameters**:
  - `content` *(required, string)*: Content to append.
  - `date` *(optional, string)*: Target date (`YYYY-MM-DD`). Default: today.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_prepend_daily_note`
Prepend text after frontmatter in today's daily note.
- **Parameters**:
  - `content` *(required, string)*: Content to prepend.
  - `date` *(optional, string)*: Target date (`YYYY-MM-DD`). Default: today.
  - `vault` *(optional, string)*: Target vault.

---

## 5. Bookmarks

### `obsidian_list_bookmarks`
List all saved bookmarks from `.obsidian/bookmarks.json`.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_create_bookmark`
Add a bookmark entry to the vault.
- **Parameters**:
  - `path` *(required, string)*: Note or file path to bookmark.
  - `title` *(optional, string)*: Custom display title for bookmark.
  - `vault` *(optional, string)*: Target vault.

---

## 6. Templates & Unique Notes

### `obsidian_list_templates`
List all template files in the vault.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_read_template`
Read the content of a template.
- **Parameters**:
  - `name` *(required, string)*: Template name or path.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_create_unique_note`
Create a Zettelkasten-prefixed note (`YYYYMMDDHHmmss title.md`).
- **Parameters**:
  - `title` *(required, string)*: Note title.
  - `content` *(optional, string)*: Initial note content.
  - `folder` *(optional, string)*: Target folder.
  - `vault` *(optional, string)*: Target vault.

---

## 7. Properties (Frontmatter)

### `obsidian_get_properties`
Read all YAML frontmatter properties from a note.
- **Parameters**:
  - `path` *(required, string)*: Note path.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_property`
Read a single property from a note's frontmatter.
- **Parameters**:
  - `path` *(required, string)*: Note path.
  - `name` *(required, string)*: Property key name.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_set_property`
Set or update a property in a note's frontmatter.
- **Parameters**:
  - `path` *(required, string)*: Note path.
  - `name` *(required, string)*: Property key name.
  - `value` *(required, any)*: Value (string, number, boolean, array, object).
  - `vault` *(optional, string)*: Target vault.

### `obsidian_remove_property`
Remove a property from a note's frontmatter.
- **Parameters**:
  - `path` *(required, string)*: Note path.
  - `name` *(required, string)*: Property key name.
  - `vault` *(optional, string)*: Target vault.

---

## 8. Tasks

### `obsidian_list_tasks`
Query tasks across the vault or within a single file.
- **Parameters**:
  - `path` *(optional, string)*: Scope to a specific file.
  - `status` *(optional, string, enum: ["all", "todo", "done"])*: Filter status. Default: `all`.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_toggle_task`
Toggle a task between `- [ ]` and `- [x]` at a specific line.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note path.
  - `line` *(required, integer)*: 1-based line number of the task.
  - `vault` *(optional, string)*: Target vault.

---

## 9. Graph, Links & Tags

### `obsidian_get_backlinks`
Find all notes linking to a target note.
- **Parameters**:
  - `file` *(required, string)*: Target note name or path.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_links`
Find all outgoing wikilinks and markdown links in a note.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note path.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_link_path`
Resolve a wikilink target string to its exact vault path.
- **Parameters**:
  - `link` *(required, string)*: Link text (e.g. `[[Project Alpha]]`).
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_orphans`
Find all notes with zero incoming and outgoing links.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_unresolved_links`
Find broken links pointing to non-existent notes.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_deadends`
Find notes that have incoming links but no outgoing links.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_tags`
List all tags with their occurrence counts across the vault.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_tag_notes`
List all notes that contain a specific tag.
- **Parameters**:
  - `tag` *(required, string)*: Tag name (with or without `#`).
  - `vault` *(optional, string)*: Target vault.

---

## 10. Obsidian Bases

### `obsidian_list_bases`
List all `.base` files in the vault.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_query_base`
Query database records and formula results from a `.base` file.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative path to the `.base` file.
  - `view` *(optional, string)*: Specific view name within the base.
  - `filter` *(optional, string)*: Filter criteria.
  - `vault` *(optional, string)*: Target vault.

### `obsidian_get_note_context`
Extract contextual frontmatter and related base records for a note.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note path.
  - `vault` *(optional, string)*: Target vault.

---

## 11. Desktop & App Controls

### `obsidian_open_in_app` / `obsidian_open_note`
Open a note or file inside the running Obsidian desktop application via URI protocol or CLI.
- **Parameters**:
  - `path` *(required, string)*: Vault-relative note or file path.
  - `newTab` *(optional, boolean)*: Open note in a new tab. Default: `false`.
  - `vault` *(optional, string)*: Target vault.
- **Returns**: `{ path: string, opened: boolean, obsidianUri: string, message: string }`

### `obsidian_execute_command`
Execute an Obsidian palette command by its ID.
- **Parameters**:
  - `commandId` *(required, string)*: Command identifier (e.g. `app:open-vault`).
  - `vault` *(optional, string)*: Target vault.

### `obsidian_list_plugins`
Inspect installed community and core plugins and their enabled status.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.

### `obsidian_list_snippets`
Inspect installed CSS snippets and their enabled status.
- **Parameters**:
  - `vault` *(optional, string)*: Target vault.
