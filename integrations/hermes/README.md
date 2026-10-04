# Hermes Agent (Nous Research) Integration

Hermes Agent natively loads skills compliant with the Agent Skills specification. You can provide the Obsidian skills to Hermes Agent using any of the following methods.

---

## Method 1: Direct Skill Directory (Recommended)

Copy the canonical skills directly into the default Hermes Agent skills path:

```bash
mkdir -p ~/.hermes/skills
cp -r skills/* ~/.hermes/skills/
```

Hermes Agent will automatically index the skills upon startup or on the next command prompt.

---

## Method 2: Configure External Skills Directory

If you maintain this repository in a separate location and wish to receive updates without copying files, add the repository's `skills/` directory to your `~/.hermes/config.yaml`:

```yaml
skills:
  external_dirs:
    - "/absolute/path/to/obsidian-universal-skills/skills"
```

---

## Method 3: Hermes CLI Tap

If your Hermes CLI installation supports Git taps:

```bash
hermes skills tap add dharmikbhesaniya/obsidian-skill
```

---

## Verification

To verify that Hermes Agent has recognized the skills:

```bash
hermes skills list
```

You should see:
- `obsidian-cli`
- `obsidian-markdown`
- `obsidian-bases`
- `json-canvas`
- `defuddle`
- `knap`
