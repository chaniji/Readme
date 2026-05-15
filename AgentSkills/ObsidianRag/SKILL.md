---
name: obsidian-rag
description: >
  Chan's Obsidian vault assistant. Use this skill whenever the user wants to
  search, find, recall, or look up anything from their notes; save something
  as a memory; or analyze the vault structure.
  Vault is at /home/chan/Works/chaniji/MarkDownFiles.
---

# Obsidian RAG — Chan's Vault

**Vault:** `/home/chan/Works/chaniji/MarkDownFiles`
**Index:** `index.md` — always read this first
**Memories:** `memories/` folder

---

## Search Notes

```bash
# Find files by keyword
grep -ril "KEYWORD" /home/chan/Works/chaniji/MarkDownFiles --include="*.md"

# Read a matched file
cat "/home/chan/Works/chaniji/MarkDownFiles/FILE.md"
```

Always cite which file the answer came from.

---

## Save Memory

Trigger: "save it as memory", "remember this", "save to memory"

```bash
mkdir -p /home/chan/Works/chaniji/MarkDownFiles/memories
```

Create file: `memories/YYYY-MM-DD-topic.md`

```markdown
---
date: YYYY-MM-DD
tags: [memory]
---

# TITLE

CONTENT
```

Then add to `index.md` under `## Memories`:
```
- [[memories/YYYY-MM-DD-topic|TITLE]]
```

Confirm: ✅ Saved to `memories/YYYY-MM-DD-topic.md`

---

## Auto Index New Files

Run at the start of every session:

```bash
find /home/chan/Works/chaniji/MarkDownFiles -name "*.md" | sort
```

Compare with what's in `index.md`. If any file is missing, add it under the matching section by folder name.

---

## Rules

- Always read `index.md` first
- Never make up info — only use what's in the files
- Always cite the source file
- Never overwrite existing memory files
