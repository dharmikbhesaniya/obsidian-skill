# GitHub Copilot Instructions for Obsidian

Place this file at `.github/copilot-instructions.md` in your vault repository.

```markdown
# Obsidian Development & Content Guidelines

## Formats and Syntax
- Always format notes using Obsidian Flavored Markdown (wikilinks `[[Note]]`, callouts `> [!NOTE]`, properties in YAML frontmatter).
- Support `.base` files with proper JSON structure and formula fields.
- Support `.canvas` files adhering to the JSON Canvas specification.

## Command Line Operations
When asked to perform actions or write automation scripts for the Obsidian vault, use the official Obsidian CLI (v1.12+):
- Parameter syntax: `obsidian <command> [subcommand] key="value" [flags]`
- Note creation: `obsidian create path="path/to/note" content="..."`
- Note append/prepend: `obsidian append path="file.md" content="..."`
- Daily notes: `obsidian daily:append content="..."`
- Tasks: `obsidian tasks daily todo`, `obsidian task path="file.md" line=N toggle`
- Search: `obsidian search query="..." format=json`
- Frontmatter properties: `obsidian property:set path="file.md" name="..." value="..."`
- Plugin developers: `obsidian plugin:reload id="..."`, `obsidian dev:errors`
```
