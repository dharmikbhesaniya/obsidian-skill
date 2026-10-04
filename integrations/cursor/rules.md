# Cursor AI Rules for Obsidian Vaults & MCP

Save this file as `.cursorrules` in your vault root or `.cursor/rules/obsidian.mdc`.

```markdown
---
description: Rules for interacting with Obsidian vaults, OFM syntax, Obsidian MCP tools, and CLI
globs: ["**/*.md", "**/*.base", "**/*.canvas"]
---

# Obsidian Knowledge & Rules

## 1. Syntax Guidelines
- Format notes using Obsidian Flavored Markdown (OFM):
  - Wikilinks: `[[Note]]` or `[[Note|Alias]]`
  - Embeds: `![[Note]]` or `![[Note#Heading]]` or `![[Note#^block-id]]`
  - Callouts: `> [!NOTE]`, `> [!TIP]`, `> [!WARNING]`, `> [!IMPORTANT]`, etc.
  - Frontmatter: Place YAML properties at the top between `---` fences.
- When creating Obsidian Bases (`.base`), ensure valid JSON schema with views, filters, and formulas.
- When creating JSON Canvas (`.canvas`), ensure valid JSON syntax with `nodes` and `edges`.

## 2. MCP Tools Operations (Recommended)
When connected to `obsidian-mcp`:
- Target specific vaults using `vault: "VaultName"`.
- Use `obsidian_patch_note` for surgical search-and-replace rather than overwriting files.
- Query notes using `obsidian_search` (with `format: "json"`), `obsidian_outline`, and `obsidian_get_backlinks`.
- Manage bookmarks via `obsidian_list_bookmarks` and `obsidian_create_bookmark`.
- Query tasks with `obsidian_list_tasks` and toggle with `obsidian_toggle_task`.

## 3. Terminal & CLI Operations (Fallback)
When executing terminal commands to manage the vault, use the official `obsidian` CLI:
- Use `key="value"` syntax: `obsidian create path="projects/plan" template="tpl" silent`
- Append to notes: `obsidian append path="projects/plan.md" content="text"`
- Daily notes: `obsidian daily:append content="- [ ] task"`
- Vault search: `obsidian search query="keyword" format=json`
- Task management: `obsidian tasks all todo`, `obsidian task path="file.md" line=10 toggle`
- Frontmatter: `obsidian property:set path="file.md" name="status" value="active"`
- Plugin development: `obsidian plugin:reload id="my-plugin"`, `obsidian dev:errors`
```
