# Universal Obsidian Suite: Skills & Plugins for AI Agents

[![Version](https://img.shields.io/badge/version-v1.6.0-blue.svg)](https://github.com/dharmikbhesaniya/obsidian-skill)
[![Obsidian](https://img.shields.io/badge/Obsidian-v1.12%2B-7C3AED?logo=obsidian&logoColor=white)](https://obsidian.md)
[![Agent Skills](https://img.shields.io/badge/Agent_Skills-Standard-green.svg)](https://agentskills.io/specification)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Universal Obsidian Suite is an enterprise-grade automation and knowledge system for [Obsidian](https://obsidian.md). It provides standardized capabilities for AI coding agents, assistants, and IDEs to inspect, author, query, and manage Obsidian vaults with full fidelity.

The repository offers three complementary delivery formats:
1. **Agent Skills**: Open instruction modules adhering to the [Agent Skills standard](https://agentskills.io/specification), discoverable across 20+ AI agents.
2. **AI Plugins & Integrations**: Pre-packaged plugins and prompt rules configured for Claude Code, OpenAI API / ChatGPT, Cursor, Google Antigravity, GitHub Copilot, and Windsurf.
3. **Model Context Protocol (MCP) Skill**: Operational instructions built specifically for the companion MCP repository: [dharmikbhesaniya/obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp).

---

## Table of Contents

- [Overview & Architecture](#overview--architecture)
- [Feature & Capability Matrix](#feature--capability-matrix)
- [Companion MCP Server Requirement](#companion-mcp-server-requirement)
- [Reliability & Silent Failure Guardrails](#reliability--silent-failure-guardrails)
- [Quick Start](#quick-start)
- [Platform & Setup Guides](#platform--setup-guides)
  - [1. Anthropic Claude Ecosystem](#1-anthropic-claude-ecosystem)
  - [2. OpenAI & ChatGPT](#2-openai--chatgpt)
  - [3. Cursor IDE](#3-cursor-ide)
  - [4. Google Antigravity & Gemini IDE](#4-google-antigravity--gemini-ide)
  - [5. Codex & OpenCode](#5-codex--opencode)
  - [6. Snowflake Cortex Code](#6-snowflake-cortex-code)
  - [7. GitHub Copilot](#7-github-copilot)
  - [8. Windsurf / Codeium Cascade](#8-windsurf--codeium-cascade)
  - [9. Hermes Agent (Nous Research)](#9-hermes-agent-nous-research)
  - [Community Integrations](#community-integrations)
- [CLI Prerequisites & Operating System Setup](#cli-prerequisites--operating-system-setup)
- [Practical Workflows & Command Examples](#practical-workflows--command-examples)
- [Evaluation & Benchmark Suite](#evaluation--benchmark-suite)
- [Detailed References](#detailed-references)
- [Maintenance & Single Source of Truth](#maintenance--single-source-of-truth)
- [License](#license)

---

## Overview & Architecture

Modern AI agents often produce incomplete changes in Obsidian vaults because desktop IPC semantics differ from conventional disk file edits. This suite resolves those mismatches across three architectural layers:

```
┌─────────────────────────────────────────────────────────────┐
│                      Universal Suite                        │
├──────────────────────────────┬──────────────────────────────┤
│ Canonical Skills (skills/)   │ Pre-built Integrations       │
│ • obsidian-cli (130+ cmds)   │ • Claude Code Plugins        │
│ • obsidian-mcp (54 tools)*   │ • OpenAI Tools / ChatGPT     │
│ • obsidian-markdown (OFM)    │ • Cursor MDC Rules           │
│ • obsidian-bases (Databases) │ • Copilot & Windsurf Rules   │
│ • json-canvas (.canvas)      │ • Google Antigravity Plugin  │
│ • defuddle (Web parser)      │ • Snowflake Cortex           │
│ • knap (Batch templating)    │ • Hermes Agent               │
└──────────────────────────────┴──────────────────────────────┘
```

- **Skills Layer (`skills/`)**: Standalone markdown specifications readable directly by any LLM or Agent Skills runner.
- **Plugins Layer (`plugins/`)**: Pre-configured packages for marketplace installation in systems supporting the Claude Plugin specification.
- **Integrations Layer (`integrations/`)**: Drop-in configuration files, OpenAI function schemas, and IDE prompt rules.

---

## Feature & Capability Matrix

| Capability | Skill Path | Supported Formats / Tools | What It Enables |
| :--- | :--- | :--- | :--- |
| **CLI Automation** | [`skills/obsidian-cli`](skills/obsidian-cli) | Official Obsidian CLI (v1.12+) | Vault administration: 130+ commands for note CRUD, daily notes, search, tasks, tags, properties, bookmarks, templates, outline, aliases, wordcount, random/unique notes, sync, bases, desktop open, snippets, and developer inspection. |
| **MCP Integration** | [`skills/obsidian-mcp`](skills/obsidian-mcp) | Model Context Protocol | 54 strongly typed semantic operations for vault authoring, surgical patching, property management, task toggling, graph links, and multi-vault isolation. *(Works exclusively with the companion repository: [dharmikbhesaniya/obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp))*. |
| **Obsidian Markdown** | [`skills/obsidian-markdown`](skills/obsidian-markdown) | `.md` (OFM) | Authoring with native wikilinks (`[[Note]]`), block embeds (`![[Note#^id]]`), callouts (`> [!NOTE]`), and frontmatter properties. |
| **Obsidian Bases** | [`skills/obsidian-bases`](skills/obsidian-bases) | `.base` | Creating and managing database schemas, formulas, table/card/list views, filters, and aggregations. |
| **JSON Canvas** | [`skills/json-canvas`](skills/json-canvas) | `.canvas` | Creating visual graphs, cards, file nodes, edges, labels, and group boundaries according to JSON Canvas spec. |
| **Web Content Parsing** | [`skills/defuddle`](skills/defuddle) | `defuddle` CLI | Extracting clean, structured Markdown from web pages to minimize agent context window and token usage. |
| **Template Batching** | [`skills/knap`](skills/knap) | `knap` CLI | Rendering liquid-style Markdown templates from JSON/CSV files and batch-generating structured notes. |

---

## Companion MCP Server Requirement

> [!IMPORTANT]
> **Exclusive Compatibility Notice**:
> The [`obsidian-mcp`](skills/obsidian-mcp) skill is engineered exclusively for and works only with the official companion repository: **[dharmikbhesaniya/obsidian-mcp](https://github.com/dharmikbhesaniya/obsidian-mcp)**.
> It requires the typed semantic tools, atomic path isolation guards, optimistic concurrency locking (`expectedRevision`), and multi-vault targeting implemented in that companion MCP server. Ensure that server is configured and running in your agent environment.

### MCP Configuration: Single Vault vs. Multi-Vault

When adding the companion server to your AI desktop client (such as Claude Desktop, Cursor, or Google Antigravity), use the following patterns:

#### 1. Single Vault Configuration (Standard or Read-Only)
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault",
        "READ_ONLY": "false"
      }
    }
  }
}
```
*Tip*: Set `"READ_ONLY": "true"` to prevent the AI from making any edits or deletions.

#### 2. Multi-Vault Configuration (Single Server with Vault Routing)
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULTS": "work=/Users/username/Documents/WorkVault,personal=/Users/username/Documents/PersonalVault",
        "OBSIDIAN_DEFAULT_VAULT": "work",
        "READ_ONLY": "false"
      }
    }
  }
}
```
*How it works*: The AI discovers both vaults via `obsidian_list_vaults` and routes commands specifying `"vault": "personal"` to the personal vault, while falling back to `work` by default.

#### 3. Multi-Vault with Separate Server Blocks (Independent Permissions)
```json
{
  "mcpServers": {
    "obsidian_work": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/WorkVault",
        "READ_ONLY": "false"
      }
    },
    "obsidian_personal": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/PersonalVault",
        "READ_ONLY": "true"
      }
    }
  }
}
```

### Essential Environment Variables

| Variable | Importance & Function |
| :--- | :--- |
| `OBSIDIAN_VAULT_PATH` | Defines the isolated filesystem root for a single vault. All agent file operations are strictly sandboxed inside this path. |
| `OBSIDIAN_VAULTS` | Defines multiple named vaults using `name=path,name2=path2`. Enables agent switching across multiple repositories. |
| `OBSIDIAN_DEFAULT_VAULT` | Specifies the default target vault when an AI tool call omits an explicit `vault` argument. |
| `READ_ONLY` | Safety toggle (`true`/`false`). When `true`, strips all write, delete, and command execution capabilities, guaranteeing no notes are modified. |
| `AUTH_ENABLED` & `AUTH_TOKEN` | Cryptographic passkey validation preventing unauthorized processes from interacting with private vaults. |

---

## Reliability & Silent Failure Guardrails

Obsidian CLI commands communicate over desktop IPC and can return exit code `0` even when output is incomplete or empty. This suite enforces standard workarounds for known failure modes:

| Operation | Default Naive Command (Produces Silent Issue) | Guarded Command Enforced by Suite | Rationale |
| :--- | :--- | :--- | :--- |
| **Task Listing** | `obsidian tasks todo` *(returns 0 tasks if active tab is not note)* | `obsidian tasks all todo` | Ensures vault-wide scope instead of relying on the active window. |
| **Tag Counting** | `obsidian tags counts` *(returns empty output)* | `obsidian tags all counts` | Explicitly targets all notes across the vault. |
| **Property Output** | `obsidian properties format=json` *(returns YAML text)* | `obsidian properties format=tsv` | Provides deterministic tabular data that agents can parse reliably. |
| **Search Queries** | `obsidian search query="text"` *(unstructured text)* | `obsidian search query="text" format=json matches` | Produces structured JSON objects with line and match offsets. |
| **File Creation** | `obsidian create path="x.md"` *(focuses desktop UI tab)* | `obsidian create path="x.md" silent` | Prevents modal interference and background process stalls. |
| **Error Handling** | Checking only `$?` exit code *(often returns `0` on error)* | Output validation for `Error:` prefix | Guarantees error detection regardless of shell exit code. |

For detailed failure reproductions and edge cases, see the [CLI Reliability Rules](skills/obsidian-cli/references/reliability-rules.md).

---

## Quick Start

### Option A: Install via Claude Code Plugin Marketplace
```bash
/plugin marketplace add https://github.com/dharmikbhesaniya/obsidian-skill
/plugin install obsidian@obsidian-skill
```

### Option B: Use as Portable Skills (Cursor, Codex, Local Agents)
```bash
# Copy into project or global skills directory
mkdir -p .agents/skills
cp -r skills/* .agents/skills/
```

### Option C: Use with OpenAI Function Calling
Integrate [`integrations/openai/function_tools.json`](integrations/openai/function_tools.json) into your agent runtime tool definitions.

---

## Platform & Setup Guides

### 1. Anthropic Claude Ecosystem

#### Claude Code (CLI)

* **Marketplace Installation (Recommended)**:
  ```bash
  /plugin marketplace add https://github.com/dharmikbhesaniya/obsidian-skill
  /plugin install obsidian@obsidian-skill
  ```
  *To install only the standalone CLI skill:*
  ```bash
  /plugin install obsidian-cli@obsidian-skill
  ```

* **Local Plugin Load**:
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

* **Direct Skills Directory**:
  ```bash
  mkdir -p .claude/skills
  cp -r skills/* .claude/skills/
  ```

#### Claude Desktop & Web
Paste the instructions from [`skills/obsidian-cli/SKILL.md`](skills/obsidian-cli/SKILL.md) and [`skills/obsidian-markdown/SKILL.md`](skills/obsidian-markdown/SKILL.md) into your Project Knowledge or Custom Instructions.

---

### 2. OpenAI & ChatGPT

#### ChatGPT (Custom GPTs & Custom Instructions)
1. Open ChatGPT &rarr; **Explore GPTs** &rarr; **Create a GPT** (or go to **Settings &rarr; Custom Instructions**).
2. Copy the instructions from [`integrations/openai/chatgpt_custom_instructions.md`](integrations/openai/chatgpt_custom_instructions.md) into the configuration prompt.

#### OpenAI API & Function Calling
Use the JSON tool definitions schema in [`integrations/openai/function_tools.json`](integrations/openai/function_tools.json) to enable structured tool calling against the CLI.

---

### 3. Cursor IDE

#### As Native Skills
Cursor auto-discovers skills placed in `~/.cursor/skills`:
```bash
mkdir -p ~/.cursor/skills
cp -r skills/* ~/.cursor/skills/
```

#### As Cursor Rules (`.cursorrules` or `.cursor/rules/`)
Copy [`integrations/cursor/rules.md`](integrations/cursor/rules.md) into `.cursorrules` or `.cursor/rules/obsidian.mdc` in your workspace.

---

### 4. Google Antigravity & Gemini IDE

#### Direct MCP Server Connection (Recommended)
Add to your Antigravity configuration at `~/.gemini/config/mcp_config.json`:
```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": ["/path/to/obsidian-mcp/dist/index.js"],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault",
        "OBSIDIAN_VAULTS": "{\"Primary\":\"/Users/username/Documents/MyVault\",\"Work\":\"/Users/username/Documents/WorkVault\"}",
        "OBSIDIAN_DEFAULT_VAULT": "Primary"
      }
    }
  }
}
```
For ready-to-copy configs, see [`integrations/antigravity/mcp_config.json`](integrations/antigravity/mcp_config.json).

#### As Workspace Skills & Rules
```bash
mkdir -p .agents/skills
cp -r skills/* .agents/skills/

mkdir -p .agents/rules
cp integrations/antigravity/rules.md .agents/rules/obsidian.md
```

---

### 5. Codex & OpenCode

#### Codex
```bash
mkdir -p ~/.codex/skills
cp -r skills/* ~/.codex/skills/
```

#### OpenCode
```bash
git clone https://github.com/dharmikbhesaniya/obsidian-skill.git ~/.opencode/skills/obsidian-skill
```

---

### 6. Snowflake Cortex Code

```bash
# Remote install
/skill add https://github.com/dharmikbhesaniya/obsidian-skill.git

# Local user install
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

### 9. Hermes Agent (Nous Research)

#### Direct Skills Directory
Hermes Agent indexes skills directly from its local skills storage:
```bash
mkdir -p ~/.hermes/skills
cp -r skills/* ~/.hermes/skills/
```

#### Via External Skills Configuration
Add the canonical `skills/` path to `~/.hermes/config.yaml`:
```yaml
skills:
  external_dirs:
    - "/path/to/obsidian-universal-skills/skills"
```

For full details, see [`integrations/hermes/README.md`](integrations/hermes/README.md).

---

### Community Integrations

The following tools accept the standard `SKILL.md` format without special modification:

| Environment | Integration Method |
| :--- | :--- |
| **Nanoclaw** | Copy `skills/` into `.claude/skills/` |
| **Openclaw** | Copy `skills/` into project `skills/` folder |
| **Cline / Continue.dev** | Add `SKILL.md` instructions into system instructions |
| **Aider** | Run `aider --read skills/obsidian-cli/SKILL.md` |
| **Local LLMs (Ollama, LM Studio)** | Include `SKILL.md` contents in system prompt |

---

## CLI Prerequisites & Operating System Setup

The Obsidian CLI communicates with the desktop application over local Inter-Process Communication (IPC).

| Prerequisite | Setting / Requirement |
| :--- | :--- |
| **Obsidian Version** | **v1.12.0+** (Desktop) |
| **Enable CLI** | In Obsidian: **Settings &rarr; Command line interface &rarr; Toggle ON** |
| **Application State** | Obsidian desktop **must be running** during CLI execution |

### Operating System Guidelines

* **macOS / Linux**:
  The `obsidian` binary is added to shell `PATH` automatically upon enabling the toggle.
* **Windows**:
  - The CLI executable requires `Obsidian.com` placed beside `Obsidian.exe`.
  - Always execute from **standard user terminals** (elevated Administrator privileges isolate IPC sessions and cause commands to fail silently).
  - When using **Git Bash / MSYS2**, configure a wrapper script at `~/bin/obsidian`:
    ```bash
    #!/bin/bash
    /c/path/to/Obsidian.com "$@"
    ```
* **Headless Linux / CI Environments**:
  - Use the official `.deb` package.
  - Run under a virtual frame buffer: `xvfb-run obsidian <command>` or prefix `DISPLAY=:5`.
  - Ensure systemd unit configurations include `PrivateTmp=false`.

---

## Practical Workflows & Command Examples

### 1. Note CRUD and Daily Notes
```bash
# Append an item to today's daily note
obsidian daily:append content="- [ ] Review sprint backlog"

# Read note contents
obsidian read path="projects/roadmap.md"

# Create a note from template without opening UI tabs
obsidian create path="meetings/2026-10-04.md" template="meeting-template" silent
```

### 2. Vault-Wide Search & Task Aggregation
```bash
# Structured JSON search across all vault files
obsidian search query="Architecture" format=json | jq '.[].path'

# Query all incomplete tasks across the entire vault
obsidian tasks all todo

# Identify orphaned notes (no incoming or outgoing links)
obsidian orphans

# Identify broken links across the vault
obsidian unresolved
```

### 3. Frontmatter & Metadata Management
```bash
# Read properties in deterministic TSV format
obsidian properties path="projects/roadmap.md" format=tsv

# Set metadata property
obsidian property:set path="projects/roadmap.md" name="status" value="in-progress"
```

### 4. Plugin & Theme Developer Lifecycle
```bash
# 1. Hot reload plugin after source code updates
obsidian plugin:reload id="my-plugin-id"

# 2. Inspect runtime errors
obsidian dev:errors

# 3. Query DOM state or CSS computed values
obsidian dev:dom selector=".workspace-leaf" text
obsidian dev:css selector=".workspace-leaf" prop=background-color

# 4. Capture debug screenshot
obsidian dev:screenshot path="tests/debug.png"
```

### 5. Web Content Extraction & Batch Templating
```bash
# Extract clean Markdown from web content and render into vault notes
defuddle parse https://example.com/article --md --json \
  | knap render template.md --data - -o notes/article.md
```

---

## Evaluation & Benchmark Suite

An automated prompt classification dataset and interactive review UI are provided in [`eval/`](eval/):
- **[`eval/eval_set.json`](eval/eval_set.json)**: 42 test cases across 4 test suites:
  1. **Intent Classification**: Validates correct skill routing for note creation, daily notes, task queries, canvas manipulation, and database queries.
  2. **Negative Triggers**: Confirms the agent avoids activating Obsidian skills on general Markdown, unrelated code tasks, or third-party plugin syntaxes.
  3. **Behavioral CLI Regressions**: Enforces verified workarounds for silent failure traps (`tasks all todo`, `tags all counts`, `format=tsv`, `silent`).
  4. **Multi-Step Workflows**: End-to-end verification sequences (e.g., Note Creation &rarr; Frontmatter Property Setup &rarr; Retrieval Verification).
- **[`eval/eval_review.html`](eval/eval_review.html)**: Interactive browser UI for visualizing evaluation benchmarks and test coverage.

---

## Detailed References

- [CLI 130+ Command Reference](skills/obsidian-cli/references/command-reference.md)
- [CLI Reliability & Silent Failure Rules](skills/obsidian-cli/references/reliability-rules.md)
- [Obsidian Callouts Reference](skills/obsidian-markdown/references/CALLOUTS.md)
- [Obsidian Embeds Reference](skills/obsidian-markdown/references/EMBEDS.md)
- [Obsidian Properties Reference](skills/obsidian-markdown/references/PROPERTIES.md)
- [Obsidian Bases Formula Reference](skills/obsidian-bases/references/FUNCTIONS_REFERENCE.md)
- [JSON Canvas Examples](skills/json-canvas/references/EXAMPLES.md)

---

## Maintenance & Single Source of Truth

The canonical source of truth for all skills is maintained under [`skills/`](skills/).

To propagate updates from `skills/` to the pre-packaged plugin mirrors without divergence, run:

```bash
bash sync_plugins.sh
```

This updates:
- `plugins/obsidian/skills/` (full suite mirror)
- `plugins/obsidian-cli/skills/obsidian-cli/` (standalone CLI mirror)

---

## License

MIT License. See [LICENSE](LICENSE) for full details.
