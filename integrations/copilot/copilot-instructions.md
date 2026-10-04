# GitHub Copilot Instructions for Obsidian

Place this file at `.github/copilot-instructions.md` in your vault repository.

```markdown
# Obsidian Development & Content Guidelines

## Formats and Syntax
- Always format notes using Obsidian Flavored Markdown (wikilinks `[[Note]]`, callouts `> [!NOTE]`, properties in YAML frontmatter).
- Support `.base` files with proper JSON structure and formula fields.
- Support `.canvas` files adhering to the JSON Canvas specification.

## MCP Protocol Workflows
When using Model Context Protocol (`obsidian-mcp`):
- Multi-vault awareness: Supply `"vault": "VaultName"` to target specific vaults.
- Safe modifications: Use `obsidian_patch_note` for targeted changes. Use `obsidian_append_note` / `obsidian_prepend_note` for additions.
- Discovery: Use `obsidian_search`, `obsidian_outline`, `obsidian_list_tasks`, and `obsidian_get_backlinks`.
- Deletions: `obsidian_delete_note` preserves files in vault trash by default.

## Command Line Operations (Fallback)
When asked to perform actions or write automation scripts using the official Obsidian CLI (v1.12+):
- Parameter syntax: `obsidian <command> [subcommand] key="value" [flags]`
- Note creation: `obsidian create path="path/to/note" content="..." silent`
- Note append/prepend: `obsidian append path="file.md" content="..."`
- Daily notes: `obsidian daily:append content="..."`
- Tasks: `obsidian tasks all todo`, `obsidian task path="file.md" line=N toggle`
- Search: `obsidian search query="..." format=json`
- Frontmatter properties: `obsidian property:set path="file.md" name="..." value="..."`
- Plugin developers: `obsidian plugin:reload id="..."`, `obsidian dev:errors`
```
