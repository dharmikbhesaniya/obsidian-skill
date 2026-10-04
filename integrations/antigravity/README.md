# Google Antigravity & Gemini IDE Integration

This guide explains how to connect Google Antigravity and Gemini IDE to your local Obsidian vault using `obsidian-mcp`.

---

## 1. Fast Setup (Local Stdio)

1. Build or clone `obsidian-mcp`:
   ```bash
   git clone https://github.com/dharmikbhesaniya/obsidian-mcp.git
   cd obsidian-mcp
   npm install && npm run build
   ```

2. Open your Antigravity global MCP configuration at `~/.gemini/config/mcp_config.json`.

3. Add the `obsidian` server entry (see [`mcp_config.json`](mcp_config.json)):
   ```json
   {
     "mcpServers": {
       "obsidian": {
         "command": "node",
         "args": [
           "/path/to/obsidian-mcp/dist/index.js"
         ],
         "env": {
           "OBSIDIAN_VAULT_PATH": "/Users/username/Documents/MyVault"
         }
       }
     }
   }
   ```

4. For multiple vaults, supply `OBSIDIAN_VAULTS`:
   ```json
   {
     "mcpServers": {
       "obsidian": {
         "command": "node",
         "args": [
           "/path/to/obsidian-mcp/dist/index.js"
         ],
         "env": {
           "OBSIDIAN_VAULT_PATH": "/Users/username/Vaults/Primary",
           "OBSIDIAN_VAULTS": "{\"Primary\":\"/Users/username/Vaults/Primary\",\"Work\":\"/Users/username/Vaults/Work\"}",
           "OBSIDIAN_DEFAULT_VAULT": "Primary"
         }
       }
     }
   }
   ```

5. Restart Antigravity or open a new conversation. Antigravity will automatically discover all 51 tools (`obsidian_read_note`, `obsidian_patch_note`, `obsidian_search`, `obsidian_list_vaults`, etc.).

---

## 2. Agent Instruction Rules

To ensure Antigravity agents follow safe editing and search workflows when interacting with your vault, add the contents of [`rules.md`](rules.md) to your workspace rules:

```bash
mkdir -p .agents/rules
cp integrations/antigravity/rules.md .agents/rules/obsidian.md
```

Or copy the contents into `~/.gemini/config/rules/obsidian.md` for global availability.

---

## 3. Remote / Daemon SSE Setup

If running `obsidian-mcp` as a shared background service:

```json
{
  "mcpServers": {
    "obsidian": {
      "url": "http://127.0.0.1:3000/sse",
      "headers": {
        "Authorization": "Bearer your-secret-token"
      }
    }
  }
}
```
