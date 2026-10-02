# Universal Obsidian Suite: Skills & Plugins for AI Agents

A complete, production-grade intelligence and automation suite for [Obsidian](https://obsidian.md). This repository provides two complementary integration architectures:
1. **Agent Skills**: Modular, discoverable instruction modules following the [Agent Skills specification](https://agentskills.io/specification).
2. **AI Plugins**: Packaged marketplace plugins and custom instruction packages for all major AI coding agents, IDEs, and assistants.

---

## 🌟 Feature & Capability Matrix

| Capability | Skill Path | Supported Formats / Tools | What It Enables |
| :--- | :--- | :--- | :--- |
| **CLI Automation** | [`skills/obsidian-cli`](skills/obsidian-cli) | Official Obsidian CLI (v1.12+) | Full terminal control: 130+ commands for note CRUD, daily notes, search, tasks, tags, properties, bookmarks, templates, sync, and plugin/theme hot-reloading. |
| **Obsidian Markdown** | [`skills/obsidian-markdown`](skills/obsidian-markdown) | `.md` (OFM) | Authoring with native wikilinks (`[[Note]]`), block embeds (`![[Note#^id]]`), callouts (`> [!NOTE]`), and frontmatter properties. |
| **Obsidian Bases** | [`skills/obsidian-bases`](skills/obsidian-bases) | `.base` | Creating and managing database schemas, formulas, table/card/list views, filters, and aggregations. |
| **JSON Canvas** | [`skills/json-canvas`](skills/json-canvas) | `.canvas` | Creating visual graphs, cards, file nodes, edges, labels, and group boundaries according to JSON Canvas spec. |
| **Web Content Parsing** | [`skills/defuddle`](skills/defuddle) | `defuddle` CLI | Extracting clean, ad-free Markdown from web pages to minimize agent context window and token usage. |
| **Template Batching** | [`skills/knap`](skills/knap) | `knap` CLI | Rendering liquid-style Markdown templates from JSON/CSV files and batch-generating structured notes. |

---

## 🚀 Setup Guides: Skills vs Plugins Across AI Systems

### 1. Anthropic Claude Ecosystem

#### Claude Code (CLI)

* **As a Plugin (Marketplace)**:
  ```bash
  /plugin marketplace add https://github.com/dharmikbhesaniya/obsidian-skill
  /plugin install obsidian@obsidian-skill
  ```
  *To install only the standalone CLI plugin:*
  ```bash
  /plugin install obsidian-cli@obsidian-skill
  ```

* **As a Local Plugin**:
  ```bash
  claude --plugin-dir ./obsidian-universal-skills
  ```

* **Persistent via `.claude/settings.json`**:
  ```json
  {
    "plugins": {
      "obsidian": {
        "source": { "source": "github", "repo": "dharmikbhesaniya/obsidian-skill" }
      }
    }
  }
  ```

* **As Modular Skills**:
  Copy the [`skills/`](skills/) folder directly into `.claude/skills/` in your vault or workspace root:
  ```bash
  mkdir -p .claude/skills
  cp -r skills/* .claude/skills/
  ```

#### Claude Desktop & Web
- Paste the instructions from [`skills/obsidian-cli/SKILL.md`](skills/obsidian-cli/SKILL.md) and [`skills/obsidian-markdown/SKILL.md`](skills/obsidian-markdown/SKILL.md) into your **Project Knowledge** or **Custom Instructions**.

---

### 2. OpenAI & ChatGPT Ecosystem

#### ChatGPT (Custom GPTs & Custom Instructions)
1. Open ChatGPT &rarr; **Explore GPTs** &rarr; **Create a GPT** (or go to **Settings &rarr; Custom Instructions**).
2. Copy the prepared instructions from [`integrations/openai/chatgpt_custom_instructions.md`](integrations/openai/chatgpt_custom_instructions.md) into the **Instructions** field.

#### OpenAI API & Function Calling Agents
- Use the complete tool definitions schema in [`integrations/openai/function_tools.json`](integrations/openai/function_tools.json) to enable direct structured function calling against the Obsidian CLI.

---

### 3. Cursor IDE

#### As Native Skills (Recommended)
Cursor auto-discovers skills placed in `~/.cursor/skills`:
```bash
mkdir -p ~/.cursor/skills
cp -r skills/* ~/.cursor/skills/
```

#### As Cursor Rules (`.cursorrules`)
Copy the rule template from [`integrations/cursor/rules.md`](integrations/cursor/rules.md) into `.cursorrules` or `.cursor/rules/obsidian.mdc` at the root of your vault.

---

### 4. Google Antigravity & Gemini IDE

#### As a Plugin
Copy the repository into your global or workspace customizations root:
```bash
# Workspace plugin installation
mkdir -p .agents/plugins/obsidian
cp -r ./* .agents/plugins/obsidian/
```

#### As Skills
Copy the skills directory to the workspace skills directory:
```bash
mkdir -p .agents/skills
cp -r skills/* .agents/skills/
```

---

### 5. Codex & OpenCode

#### Codex
```bash
mkdir -p ~/.codex/skills
cp -r skills/* ~/.codex/skills/
```

#### OpenCode
Clone the full repository into the OpenCode skills path:
```bash
git clone https://github.com/dharmikbhesaniya/obsidian-skill.git ~/.opencode/skills/obsidian-skill
```
OpenCode automatically discovers all `SKILL.md` files upon restart.

---

### 6. Snowflake Cortex Code
```bash
# Remote install
/skill add https://github.com/dharmikbhesaniya/obsidian-skill.git

# Or user-level install
mkdir -p ~/.snowflake/cortex/skills
cp -r skills/* ~/.snowflake/cortex/skills/
```

---

### 7. GitHub Copilot (VS Code)
Copy [`integrations/copilot/copilot-instructions.md`](integrations/copilot/copilot-instructions.md) to `.github/copilot-instructions.md` in your vault repository.

---

### 8. Windsurf / Codeium Cascade
Copy [`integrations/windsurf/obsidian_rules.md`](integrations/windsurf/obsidian_rules.md) to `.windsurf/rules/obsidian.md`.

---

### 9. Nanoclaw & Openclaw
```bash
# Nanoclaw
mkdir -p .claude/skills/obsidian-cli
cp -r skills/obsidian-cli/* .claude/skills/obsidian-cli/

# Openclaw
mkdir -p skills
cp -r skills/* skills/
```

---

### 10. Local LLMs & Other Coding Assistants (Ollama, Cline, Continue.dev, Aider)
- For **Cline / Continue.dev**: Add [`skills/obsidian-cli/SKILL.md`](skills/obsidian-cli/SKILL.md) and [`skills/obsidian-markdown/SKILL.md`](skills/obsidian-markdown/SKILL.md) to your custom prompt or system rules file.
- For **Aider**: Run `aider --read skills/obsidian-cli/SKILL.md`.

---

## 🛠️ Obsidian CLI Prerequisites & Platform Setup

The CLI communicates with the desktop application over local Inter-Process Communication (IPC).

| Prerequisite | Setting / Requirement |
| :--- | :--- |
| **Obsidian Version** | **v1.12.0+** (Desktop) |
| **Enable CLI** | In Obsidian: **Settings &rarr; Command line interface &rarr; Toggle ON** |
| **Application State** | Obsidian desktop **must be running** during CLI execution |

### Platform-Specific Notes

* **macOS / Linux**: The binary is automatically added to your shell `PATH`.
* **Windows**:
  - The CLI requires `Obsidian.com` located next to `Obsidian.exe`.
  - Always run in **standard user terminals** (elevated Administrator terminals block IPC).
  - If using **Git Bash / MSYS2**, configure a wrapper script at `~/bin/obsidian`:
    ```bash
    #!/bin/bash
    /c/path/to/Obsidian.com "$@"
    ```
* **Headless Linux / CI**:
  - Use the official `.deb` package.
  - Execute under `xvfb`: `xvfb-run obsidian <command>` or prefix `DISPLAY=:5`.
  - Ensure systemd unit services have `PrivateTmp=false`.

---

## 📖 Practical Workflows & Examples

### 1. Note CRUD and Daily Notes
```bash
# Append a task to today's daily note
obsidian daily:append content="- [ ] Ship feature update"

# Read note contents
obsidian read path="projects/roadmap.md"

# Create a note with initial content or from template
obsidian create path="meetings/2026-10-02" template="meeting-template" silent
```

### 2. Search & Vault Analysis
```bash
# Full text search returning JSON
obsidian search query="Architecture" format=json | jq '.[].path'

# Query incomplete tasks across the entire vault
obsidian tasks | grep "\[ \]"

# Graph analysis: find orphaned notes with no links
obsidian orphans

# Find broken internal links
obsidian unresolved
```

### 3. Plugin & Theme Developer Lifecycle
```bash
# 1. Hot reload plugin after code edits
obsidian plugin:reload id="my-plugin-id"

# 2. Check for runtime errors
obsidian dev:errors

# 3. Inspect DOM elements or CSS properties
obsidian dev:dom selector=".workspace-leaf" text
obsidian dev:css selector=".workspace-leaf" prop=background-color

# 4. Capture screenshot
obsidian dev:screenshot path="tests/debug.png"
```

### 4. Web Extraction & Batch Templating
```bash
# Extract clean article markdown and batch-render into notes
defuddle parse https://example.com/article --md --json \
  | knap render template.md --data - -o notes/article.md
```

---

## 🧪 Evaluation & Benchmark Suite

An automated prompt classification dataset and interactive review UI are provided in [`eval/`](eval/):
- **[`eval/eval_set.json`](eval/eval_set.json)**: 30+ categorized test prompts for evaluating agent trigger precision.
- **[`eval/eval_review.html`](eval/eval_review.html)**: Interactive browser UI for visualizing evaluation benchmarks.

---

## 📚 Detailed References

- [CLI 130+ Command Reference](skills/obsidian-cli/references/command-reference.md)
- [Obsidian Callouts Reference](skills/obsidian-markdown/references/CALLOUTS.md)
- [Obsidian Embeds Reference](skills/obsidian-markdown/references/EMBEDS.md)
- [Obsidian Properties Reference](skills/obsidian-markdown/references/PROPERTIES.md)
- [Obsidian Bases Formula Reference](skills/obsidian-bases/references/FUNCTIONS_REFERENCE.md)
- [JSON Canvas Examples](skills/json-canvas/references/EXAMPLES.md)

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for full details.
