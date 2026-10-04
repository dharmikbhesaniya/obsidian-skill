# Obsidian MCP Tool Catalog & Companion Setup Guide

This document lists the 54 semantic tools provided by the companion MCP server repository: [dharmikbhesaniya/obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp).

> **Important**: These tools require the [obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp) runtime. They are not provided by standalone markdown files.

---

## 1. Complete Tool Catalog

### Vault Operations
- `obsidian_list_vaults`: Inventory all configured vaults and active default.
- `obsidian_get_vault`: Retrieve vault root path and desktop reachability status.
- `obsidian_list_files`: Enumerate files with optional `recursive` and `extension` filters.
- `obsidian_get_file_info`: File metadata, size, and modification timestamp.

### Note Authoring & Modification
- `obsidian_read_note`: Read note content, revision hash, and parsed frontmatter.
- `obsidian_create_note`: Create note with concurrency checks and templates.
- `obsidian_create_unique_note`: Collision-safe timestamped note creation.
- `obsidian_update_note`: Full note overwrite protected by `expectedRevision`.
- `obsidian_patch_note`: Surgical patch via search/replace, headings, blocks, or regex.
- `obsidian_append_note`: Append text to note.
- `obsidian_prepend_note`: Prepend text to note.
- `obsidian_move_note`: Rename/move with automatic inbound wikilink refactoring.
- `obsidian_delete_note`: Atomic safe trash or permanent deletion.

### Search & Discovery
- `obsidian_search`: Fast vault-wide content search.
- `obsidian_search_context`: Content search with surrounding context lines.
- `obsidian_find_notes`: Property and tag-filtered note queries.
- `obsidian_recent_changes`: Chronologically sorted list of recently modified notes.
- `obsidian_get_note_context`: Context pack containing note body, outline, backlinks, and related notes.

### Daily Notes
- `obsidian_read_daily_note`: Read date-specific or today's daily note.
- `obsidian_append_daily_note`: Append to daily note with automatic creation fallback.
- `obsidian_prepend_daily_note`: Prepend to daily note below frontmatter.

### Frontmatter & Properties
- `obsidian_get_properties`: Retrieve all frontmatter properties as JSON.
- `obsidian_get_property`: Get specific property value.
- `obsidian_set_property`: Add or update property value.
- `obsidian_remove_property`: Remove property key.

### Tasks & Checklists
- `obsidian_list_tasks`: Extract all todo and completed checklist items.
- `obsidian_toggle_task`: Toggle checklist state at specific line with verification.

### Graph & Link Analytics
- `obsidian_get_backlinks`: List incoming wikilinks.
- `obsidian_get_links`: List outgoing wikilinks.
- `obsidian_get_link_path`: Resolve shortest wikilink connection between two notes.
- `obsidian_get_orphans`: Identify unreferenced notes.
- `obsidian_get_unresolved_links`: Find broken or prospective links.
- `obsidian_get_deadends`: Find notes lacking outgoing links.

### Tags & Bases
- `obsidian_get_tags`: Vault tag inventory with frequency counts.
- `obsidian_get_tag_notes`: Notes associated with a tag.
- `obsidian_list_bases`: Discover `.base` database files.
- `obsidian_query_base`: Run structured queries against Obsidian Bases.

### Document Structure & Metrics
- `obsidian_outline` / `obsidian_get_outline`: Hierarchical heading tree with line offsets.
- `obsidian_word_count`: Metric calculations for words, characters, sentences, paragraphs, and reading time.

### Desktop Utilities & Extensions
- `obsidian_open_note` / `obsidian_open_in_app`: Focus and open note in running desktop instance.
- `obsidian_list_bookmarks`: List vault bookmarks.
- `obsidian_create_bookmark`: Add note, folder, or search to bookmarks.
- `obsidian_list_templates`: List available vault templates.
- `obsidian_read_template`: Read template file contents.
- `obsidian_list_aliases` / `obsidian_get_aliases`: Retrieve configured note aliases.
- `obsidian_random_note`: Retrieve random note path.
- `obsidian_list_plugins`: Report core and community plugins.
- `obsidian_list_snippets`: Report custom CSS snippets.
- `obsidian_list_commands`: List official Obsidian palette commands.
- `obsidian_execute_command`: Trigger palette command.

---

## 2. Connecting Client Configurations

### Claude Desktop (`claude_desktop_config.json`)
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/path/to/your/vault"
      }
    }
  }
}
```

### Google Antigravity / Gemini IDE (`~/.gemini/config/mcp_config.json`)
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/path/to/your/vault"
      }
    }
  }
}
```

### Cursor IDE (`.cursor/mcp.json`)
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/path/to/your/vault"
      }
    }
  }
}
```
