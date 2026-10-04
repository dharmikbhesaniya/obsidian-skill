# Windsurf Rules for Obsidian

Place this file at `.windsurf/rules/obsidian.md`.

```markdown
# Obsidian Vault, MCP & CLI Rules

- **Formats**: Use Obsidian Flavored Markdown (wikilinks, callouts, frontmatter properties), Obsidian Bases (`.base`), and JSON Canvas (`.canvas`).
- **MCP Server Operations**: When connected to `obsidian-mcp`:
  - Route between vaults using the optional `vault` parameter.
  - Surgically edit notes with `obsidian_patch_note` (search/replace) to avoid overwriting documents.
  - Discover structure with `obsidian_outline` and calculate reading time with `obsidian_word_count`.
  - Inspect bookmarks via `obsidian_list_bookmarks` and templates via `obsidian_list_templates`.
  - Access daily notes with `obsidian_read_daily_note` and `obsidian_append_daily_note`.
- **Terminal CLI Fallback**: When manipulating the vault via command line:
  - `obsidian read path="path/to/note.md"`
  - `obsidian create path="path/to/note" content="..." silent`
  - `obsidian append path="path/to/note.md" content="..."`
  - `obsidian daily:append content="..."`
  - `obsidian tasks all todo`
  - `obsidian property:set path="path/to/note.md" name="..." value="..."`
  - `obsidian search query="..." format=json`
  - `obsidian plugin:reload id="..."`
```
