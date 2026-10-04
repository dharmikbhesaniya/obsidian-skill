# Antigravity Rules for Obsidian Vaults

These guidelines ensure Antigravity agents interact reliably and safely with local Obsidian vaults.

---

## 1. Multi-Vault Routing
- If the user references a specific vault (e.g. "in my Work vault"), include `"vault": "Work"` in tool calls.
- If unsure which vault contains a document, call `obsidian_list_vaults` to check configured vaults.
- If no vault is specified, omit the `vault` parameter to use the default vault.

---

## 2. Note Modifications
- **Surgical Editing**: Prefer `obsidian_patch_note` with specific `search` and `replace` blocks when editing notes. Avoid full-file overwrites with `obsidian_update_note` unless explicitly asked to rewrite the note.
- **Append & Prepend**: Use `obsidian_append_note` for task logs and journal entries. Use `obsidian_prepend_note` when inserting information after frontmatter.
- **Frontmatter**: Use `obsidian_set_property` and `obsidian_get_property` rather than manually formatting YAML strings.

---

## 3. Vault Exploration & Search
- Use `obsidian_search` with `"format": "json"` for structured matches.
- Use `obsidian_outline` before editing large notes to understand heading structure.
- Check note connections using `obsidian_get_backlinks` before deleting or moving documents.
- Use `obsidian_word_count` to verify document metrics when asked for article lengths or reading summaries.

---

## 4. Safety Guardrails
- **Deletion**: Always confirm before permanent deletion. By default, `obsidian_delete_note` uses `.obsidian-mcp/trash/` for safety.
- **Paths**: All paths are relative to the vault root (e.g. `Projects/Roadmap.md`). Do not use absolute filesystem paths.
