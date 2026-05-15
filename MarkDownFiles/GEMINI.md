# Project Mandates: Obsidian Vault (MarkDownFiles)

This folder is an Obsidian vault containing resume data and technical project clippings. All agent interactions must adhere to Obsidian-specific standards and leverage the capabilities of activated Obsidian skills.

## Core Obsidian Standards

- **Obsidian Flavored Markdown (OFM):** Always use OFM for note creation and editing.
    - **Links:** Use `[[Wikilinks]]` for internal vault connections. Use standard `[text](url)` only for external links.
    - **Metadata:** Every new note must include a YAML frontmatter block with at least `tags` and `created`.
    - **Callouts:** Use `> [!type]` for highlights, warnings, or structured information (e.g., `> [!info]`, `> [!todo]`).
    - **Visuals:** Use `==Highlighting==` for emphasis and `%%Comments%%` for hidden notes.

## Skill-Specific Instructions

### 1. Obsidian Markdown (`.md`)
- **Embeds:** Use `![[embed]]` to include content from other notes or images.
- **Block IDs:** Use `^block-id` for granular linking when requested.
- **Mermaid:** Use mermaid blocks for diagrams and include `class NodeName internal-link;` to make nodes clickable within Obsidian.

### 2. Obsidian Bases (`.base`)
- When creating or editing `.base` files, ensure they are valid YAML.
- **Filters & Formulas:** Use the `formulas` section for computed properties and `filters` to scope views.
- **Duration Math:** Remember that subtracting dates returns a **Duration**. Always access a field (e.g., `.days`) before applying numeric functions like `.round()`.
- **Quoting:** Wrap formulas in single quotes if they contain double-quoted strings: `'if(done, "✅", "⏳")'`.

### 3. JSON Canvas (`.canvas`)
- When modifying canvases, ensure all node IDs are unique 16-character hex strings.
- **Validation:** Every `fromNode` and `toNode` must reference an existing node ID.
- **Types:** Support `text`, `file`, `link`, and `group` nodes.
- **Positioning:** Space nodes 50-100px apart to prevent overlapping.

## Project Context & Organization
- **Index Management:** Whenever a new note or folder is created, the `index.md` (Vault Index) **MUST** be updated immediately.
- **Title Rule:** Every folder and subfolder, regardless of nesting depth, must be a section title in `index.md`. Maintain a strict hierarchy: use H2 (##) for top-level folders and H3/H4 (###/####) for nested subfolders, creating a visual tree matching your directory structure.
- **Resume Data:** `resume.json` and `resume.yaml` are the source of truth for professional info.
- **Clippings & Note Organization:** 
    - If a clipping or note is related to **GitHub**, move it to the `GitHub/` root folder.
    - If a clipping or note is related to **MongoDB**, move it to `memories/mongodb/`.
    - If a clipping or note is related to **Eureka**, move it to `memories/Eureka/`.
    - Technical research and other project imports are stored in `Clippings/`.
- **Style:** Maintain a clean, professional, and organized structure. Prefer minimalist documentation that focuses on high-signal technical details.
