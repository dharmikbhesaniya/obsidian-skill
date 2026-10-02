# Windsurf Rules for Obsidian

Place this file at `.windsurf/rules/obsidian.md`.

```markdown
# Obsidian Vault & CLI Rules

- Formats: Use Obsidian Flavored Markdown (wikilinks, callouts, frontmatter properties), Obsidian Bases (`.base`), and JSON Canvas (`.canvas`).
- Terminal actions: When the user asks to manipulate or query their vault from the terminal, use the official `obsidian` CLI:
  - `obsidian read path="path/to/note.md"`
  - `obsidian create path="path/to/note" content="..."`
  - `obsidian append path="path/to/note.md" content="..."`
  - `obsidian daily:append content="..."`
  - `obsidian tasks daily todo`
  - `obsidian property:set path="path/to/note.md" name="..." value="..."`
  - `obsidian search query="..." format=json`
  - `obsidian plugin:reload id="..."`
```
