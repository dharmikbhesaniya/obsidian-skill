# Obsidian MCP Setup & Integration Guide

Complete integration guide for connecting AI coding assistants and environments to local Obsidian vaults via `obsidian-mcp`.

---

## 1. Installation & Build

Build the server binary locally:

```bash
git clone https://github.com/dharmikbhesaniya/obsidian-mcp.git
cd obsidian-mcp
npm install
npm run build
```

---

## 2. Environment Configuration

### Single Vault Setup
Set the path to your primary vault:
```bash
export OBSIDIAN_VAULT_PATH="/Users/username/Documents/MyVault"
```

### Multi-Vault Setup
Set multiple named vaults as a JSON string and specify the default:
```bash
export OBSIDIAN_VAULTS='{"Personal":"/Users/username/Vaults/Personal","Work":"/Users/username/Vaults/Work"}'
export OBSIDIAN_DEFAULT_VAULT="Personal"
```

### Optional Security & Scope Flags
- `OBSIDIAN_READ_ONLY=true`: Disables all mutating tools (create, update, patch, delete, append, prepend, etc.).
- `OBSIDIAN_SCOPES="notes:read,search:read"`: Enforces fine-grained permission scopes.

---

## 3. Platform Configurations

### Google Antigravity & Gemini IDE

Edit or create `~/.gemini/config/mcp_config.json`:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": [
        "/absolute/path/to/obsidian-mcp/dist/index.js"
      ],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault",
        "OBSIDIAN_VAULTS": "{\"Primary\":\"/Users/username/Documents/MyVault\",\"Work\":\"/Users/username/Documents/WorkVault\"}",
        "OBSIDIAN_DEFAULT_VAULT": "Primary"
      }
    }
  }
}
```

---

### Claude Desktop

Edit `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": [
        "/absolute/path/to/obsidian-mcp/dist/index.js"
      ],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault"
      }
    }
  }
}
```

---

### Cursor IDE

Add to `~/.cursor/mcp.json` or workspace `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": [
        "/absolute/path/to/obsidian-mcp/dist/index.js"
      ],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault"
      }
    }
  }
}
```

---

### Windsurf / Codeium Cascade

Add to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "node",
      "args": [
        "/absolute/path/to/obsidian-mcp/dist/index.js"
      ],
      "env": {
        "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault"
      }
    }
  }
}
```

---

## 4. Remote HTTP/SSE Daemon Setup

To run `obsidian-mcp` as a background service or on a local server:

```bash
OBSIDIAN_TRANSPORT=sse \
OBSIDIAN_PORT=3000 \
OBSIDIAN_HOST=127.0.0.1 \
OBSIDIAN_API_KEY="your-secure-token" \
OBSIDIAN_VAULT_PATH="/Users/username/Documents/MyVault" \
node dist/index.js
```

Then configure client MCP entries using URL mode:
```json
{
  "mcpServers": {
    "obsidian-remote": {
      "url": "http://127.0.0.1:3000/sse",
      "headers": {
        "Authorization": "Bearer your-secure-token"
      }
    }
  }
}
```

---

## 5. Testing with MCP Inspector

Test tools interactively in the browser:

```bash
npx @modelcontextprotocol/inspector node dist/index.js
```

Open the web interface URL displayed in terminal output (e.g. `http://localhost:6274`) to test all 51 tools, list resources, and run prompts.
