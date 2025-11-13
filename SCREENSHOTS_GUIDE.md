# Screenshots Guide

This document explains what screenshots/visual examples are needed for the documentation.

## Required Screenshots

### 1. Installation Process (`docs/screenshots/installation.png`)

**Command:**
```bash
bash install.sh
```

**What to capture:**
- The welcome banner
- Installation prompts
- Success messages
- Final "next steps" instructions

**Ideal tool:** [asciinema](https://asciinema.org/) for animated terminal recording

### 2. Worktree Creation (`docs/screenshots/worktree-start.gif`)

**Command:**
```bash
/worktree-start rails "Add user authentication system"
```

**What to capture:**
- Smart mode activation
- Branch name generation by Claude
- Worktree creation
- FEATURE.md generation
- Directory structure after creation

### 3. Worktree Listing (`docs/screenshots/worktree-list.png`)

**Command:**
```bash
/worktree-list
```

**What to capture:**
- List of active worktrees
- Branch names and paths
- Current worktree highlighting
- Clean, colorful output

### 4. Comparing Changes (`docs/screenshots/worktree-compare.gif`)

**Command:**
```bash
/worktree-compare feat/user-auth
```

**What to capture:**
- Statistics summary (files changed, lines added/removed)
- Commit log
- Conflict detection (if any)
- Diff preview with syntax highlighting

### 5. Merge Process (`docs/screenshots/worktree-merge.gif`)

**Command:**
```bash
/worktree-merge feat/user-auth
```

**What to capture:**
- Pre-flight checks
- Confirmation prompt
- Merge execution
- Cleanup process
- Success message

### 6. Directory Structure (`docs/screenshots/directory-structure.png`)

**Command:**
```bash
tree -L 2 -a
```

**What to show:**
- Main repository directory
- Sibling worktree directories
- .claude/commands/ structure

### 7. Before/After Comparison

**Create a side-by-side comparison showing:**

**LEFT (Without Worktrees):**
```
❌ Traditional Workflow:
- git stash
- git checkout -b feat/new-feature
- *work on feature*
- git checkout main
- git stash pop
- *conflicts, lost context*
```

**RIGHT (With Worktrees):**
```
✅ With Worktrees:
- /worktree-start rails "new feature"
- *work in ../feat/new-feature*
- *main branch untouched*
- /worktree-merge feat/new-feature
- ✅ Clean, isolated, efficient
```

## Tools Recommended

### For Terminal Recordings

1. **asciinema** (Best for CLI tools)
   ```bash
   brew install asciinema
   asciinema rec demo.cast
   # ... run commands ...
   # Ctrl+D to stop
   asciinema play demo.cast
   ```

2. **ttygif** (Convert to GIF)
   ```bash
   npm install -g ttygif
   ttygif demo.cast
   ```

3. **terminalizer** (Alternative)
   ```bash
   npm install -g terminalizer
   terminalizer record demo
   terminalizer play demo
   terminalizer render demo
   ```

### For Screenshots

1. **macOS:** CMD+Shift+4 (area selection)
2. **Linux:** Flameshot, gnome-screenshot
3. **Windows:** Win+Shift+S

### For Editing

- **ImageMagick** for batch processing
- **Gimp** for advanced editing
- **Carbon.now.sh** for beautiful code screenshots

## Directory Structure

Create this directory structure:

```
docs/
├── screenshots/
│   ├── installation.png
│   ├── worktree-start.gif
│   ├── worktree-list.png
│   ├── worktree-compare.gif
│   ├── worktree-merge.gif
│   ├── directory-structure.png
│   └── before-after.png
└── examples/
    ├── example-output-start.txt
    ├── example-output-list.txt
    ├── example-output-compare.txt
    └── example-output-merge.txt
```

## How to Add Screenshots to Documentation

### In README.md

Add after "Quick Start" section:

```markdown
## Visual Overview

### Installation

![Installation Process](docs/screenshots/installation.png)

### Creating a Worktree

![Worktree Creation](docs/screenshots/worktree-start.gif)

### Managing Worktrees

![Worktree List](docs/screenshots/worktree-list.png)
```

### In START_HERE.md

Add to "60-Second Quick Start" section:

```markdown
Here's what it looks like in action:

![Quick Demo](docs/screenshots/worktree-start.gif)
```

## Example Output Files

I've created example output files in markdown format that can be used until real screenshots are available:

- `docs/examples/example-output-*.txt`

These provide text-based examples of command output that can be embedded in documentation.

## Creating Demo Environment

To create screenshots, set up a demo environment:

```bash
# 1. Create demo Rails app
rails new demo-app
cd demo-app
git init
git add .
git commit -m "Initial commit"

# 2. Install worktree commands
mkdir -p .claude/commands
cp /path/to/worktree-*.md .claude/commands/

# 3. Start recording
asciinema rec demo.cast

# 4. Run commands
/worktree-start rails "Add user authentication"
cd ../feat/add-user-authentication
# Make some changes
echo "# Authentication" >> AUTH.md
git add . && git commit -m "Add auth docs"
cd ../demo-app
/worktree-compare feat/add-user-authentication
/worktree-merge feat/add-user-authentication

# 5. Stop recording (Ctrl+D)

# 6. Convert to GIF
ttygif demo.cast
```

## Placeholder Badge for README

Until real screenshots are available, add this badge:

```markdown
[![Screencast](https://img.shields.io/badge/screencast-coming%20soon-yellow)](docs/screenshots/)
```

## Next Steps

1. [ ] Set up demo environment
2. [ ] Record all command demonstrations
3. [ ] Create screenshots/GIFs
4. [ ] Add to documentation
5. [ ] Verify all links work
6. [ ] Update badge to show available
