# Universal Obsidian Skills for AI Coding Agents

A complete, production-ready Agent Skills suite for [Obsidian](https://obsidian.md). This repository unifies deep command-line automation (130+ CLI commands) with full-spectrum support for Obsidian formats (Obsidian Flavored Markdown, Bases databases, JSON Canvas, web extraction with Defuddle, and batch templating with Knap).

Compatible with all agents adhering to the [Agent Skills specification](https://agentskills.io/specification), including **Claude Code**, **Cursor**, **Codex**, **OpenCode**, **Cortex Code**, **GitHub Copilot**, and **Windsurf**.

---

## Included Skills

| Skill | Path | Description |
| :--- | :--- | :--- |
| **[obsidian-cli](skills/obsidian-cli)** | `skills/obsidian-cli` | Full control of Obsidian vaults via official CLI (v1.12+): 130+ commands, note CRUD, daily notes, search, properties, tasks, tags, sync history, and plugin/theme development. |
| **[obsidian-markdown](skills/obsidian-markdown)** | `skills/obsidian-markdown` | Create and format [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown) (`.md`) with wikilinks, embeds, callouts, and frontmatter properties. |
| **[obsidian-bases](skills/obsidian-bases)** | `skills/obsidian-bases` | Design and query [Obsidian Bases](https://help.obsidian.md/bases/syntax) (`.base`) with database views (tables, cards, lists), filters, formulas, and summaries. |
| **[json-canvas](skills/json-canvas)** | `skills/json-canvas` | Create and manipulate [JSON Canvas](https://jsoncanvas.org/) visual graphs (`.canvas`) with nodes, edges, groups, and connections. |
| **[defuddle](skills/defuddle)** | `skills/defuddle` | Extract clean, decluttered Markdown from web pages with [Defuddle](https://github.com/kepano/defuddle) to conserve agent token context. |
| **[knap](skills/knap)** | `skills/knap` | Render Markdown templates from JSON/CSV data and batch-generate notes using [Knap](https://github.com/obsidianmd/knap). |

---

## Prerequisites for Obsidian CLI

| Requirement | Details |
| :--- | :--- |
| **Obsidian Desktop** | **v1.12.0+** (free for all users) |
| **CLI Enabled** | Open Obsidian &rarr; Settings &rarr; Command line interface &rarr; Toggle **ON** |
| **Obsidian Running** | The desktop application must be open (communicates over local IPC) |

### OS Configuration

- **macOS / Linux**: The `obsidian` executable is added to PATH automatically upon enabling the toggle in Settings.
- **Windows**: Requires the `Obsidian.com` redirector file placed alongside `Obsidian.exe`. Run commands in standard user terminals (admin privileges disable IPC).
- **Headless Linux**: Install via official `.deb` package. Run with `xvfb` (`DISPLAY=:5`) and set `PrivateTmp=false` in systemd units.

---

## Installation Across AI Agent Platforms

### Claude Code

**Option 1 — Marketplace Install (Recommended)**
```bash
/plugin marketplace add <repo-url>
/plugin install obsidian@obsidian-universal-skills
```

**Option 2 — Direct Plugin Directory**
```bash
claude --plugin-dir ./obsidian-universal-skills
```

**Option 3 — Vault Local Copy**
Copy the `skills/` directory into the `.claude/skills/` folder inside your Obsidian vault or project root.

---

### npx skills
```bash
npx skills add <repo-url>
```

---

### Cursor
Cursor natively discovers skills placed in `~/.cursor/skills`:
```bash
mkdir -p ~/.cursor/skills
cp -r skills/* ~/.cursor/skills/
```

---

### Codex
Copy the `skills/` directory into your Codex skills path:
```bash
mkdir -p ~/.codex/skills
cp -r skills/* ~/.codex/skills/
```

---

### OpenCode
Clone the repository into the OpenCode skills path:
```bash
git clone <repo-url> ~/.opencode/skills/obsidian-universal-skills
```
OpenCode automatically discovers all `SKILL.md` files recursively upon restart.

---

### Cortex Code
```bash
/skill add <repo-url>
```
Or copy directly into user-level skills:
```bash
mkdir -p ~/.snowflake/cortex/skills
cp -r skills/* ~/.snowflake/cortex/skills/
```

---

### GitHub Copilot (VS Code)
Add repository instructions to `.github/copilot-instructions.md` or scoped to `.github/instructions/obsidian.instructions.md`.

---

### Windsurf
Copy skills into `.windsurf/rules/` and reference commands as needed.

---

## Quick Start Examples

### 1. Obsidian CLI Note Operations
```bash
# Append to today's daily note
obsidian daily:append content="- [ ] Review pull requests"

# Search vault and format output as JSON
obsidian search query="meeting notes" format=json | jq '.[].path'

# Query incomplete tasks across the entire vault
obsidian tasks | grep "\[ \]"

# Create a new note from a template
obsidian create path="projects/q4-plan" template="project-template"
obsidian property:set path="projects/q4-plan.md" name="status" value="active"
```

### 2. Plugin & Theme Development Workflow
```bash
# Reload plugin after code edits
obsidian plugin:reload id="my-custom-plugin"

# Check for runtime errors
obsidian dev:errors

# Capture visual state or inspect elements
obsidian dev:screenshot path="screenshots/debug.png"
obsidian dev:dom selector=".workspace-leaf" text
```

### 3. Defuddle & Knap Note Extraction Pipeline
```bash
# Extract web page content and batch render into a structured note
defuddle parse https://example.com/article --md --json \
  | knap render template.md --data - -o notes/article.md
```

---

## Evaluation & Testing

The repository includes a benchmark evaluation suite located in [`eval/`](eval/):
- **[`eval/eval_set.json`](eval/eval_set.json)**: Contains curated prompt cases testing positive triggers vs negative non-triggers.
- **[`eval/eval_review.html`](eval/eval_review.html)**: Interactive visual inspection interface for skill evaluations.

---

## Troubleshooting Reference

| Issue | Root Cause | Solution |
| :--- | :--- | :--- |
| Command hangs / empty output | Obsidian is not open or running in Windows Admin mode | Launch Obsidian desktop; run terminal in standard user mode |
| `command not found: obsidian` | CLI binary not in PATH | Toggle CLI setting OFF/ON in Obsidian Settings; restart shell |
| Exit code 127 on colon commands | Outdated Windows installer or Git Bash executable collision | Reinstall from [obsidian.md/download](https://obsidian.md/download); configure Git Bash wrapper |
| Linux IPC socket connection failed | Systemd sandboxing (`PrivateTmp=true`) or Snap confinement | Set `PrivateTmp=false`; install official `.deb` package |
| `template:insert` errors | Requires an active GUI tab | Use `obsidian create path="..." template="..."` for headless execution |
| List properties saved as strings | CLI writes raw strings to metadata | Edit note frontmatter directly or invoke `obsidian eval` |

---

## Full Command Reference

For detailed parameter schemas, output flags, and examples across all 130+ commands, see [`skills/obsidian-cli/references/command-reference.md`](skills/obsidian-cli/references/command-reference.md).

---

## License

MIT License. See [LICENSE](LICENSE) for details.
