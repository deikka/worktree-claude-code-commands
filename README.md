# Git Worktrees for Claude Code

Complete git worktree management system optimized for parallel development with Claude Code.

[![Version](https://img.shields.io/badge/version-1.1.0-blue)](https://github.com/deikka/worktree-claude-code-commands/releases)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/deikka/worktree-claude-code-commands/ci.yml?branch=main&label=CI)](https://github.com/deikka/worktree-claude-code-commands/actions)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](#installation)
[![Documentation](https://img.shields.io/badge/docs-complete-success)](START_HERE.md)
[![Languages](https://img.shields.io/badge/languages-English%20%7C%20Español-blue)](#languages)

> **[🇪🇸 Documentación en Español](es/README.md)** | 🇬🇧 English (current)

---

## 📖 Table of Contents

- [What is This?](#what-is-this)
- [Why Use Worktrees?](#why-use-worktrees)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Available Commands](#available-commands)
- [Complete Documentation](#complete-documentation)
- [Workflows](#workflows)
- [Best Practices](#best-practices)
- [FAQ](#faq)
- [Troubleshooting](#troubleshooting)
- [Languages](#languages)
- [Contributing](#contributing)

---

## 🎬 Visual Examples

Want to see it in action? Check out these example outputs:

- **[Creating a Worktree](docs/examples/example-output-start.txt)** - Smart mode with AI branch name generation
- **[Listing Worktrees](docs/examples/example-output-list.txt)** - Overview of all active worktrees
- **[Comparing Changes](docs/examples/example-output-compare.txt)** - Detailed diff before merge
- **[Merging & Cleanup](docs/examples/example-output-merge.txt)** - Safe merge with automatic cleanup

> **Note:** Screenshots and recordings coming soon! See [SCREENSHOTS_GUIDE.md](SCREENSHOTS_GUIDE.md) for details.

---

## 🎉 What's New in v1.2.0

**Latest Release:** November 14, 2025

### ✨ New Features
- **🎯 Interactive Mode** - Perfect for beginners! Run `/worktree-start -i "feature"`
  - Guided experience with visual prompts
  - Choose change type (feature/bugfix/hotfix/refactor)
  - Preview and edit branch name before creation
  - Confirm all steps with visual summary
  - Arrow key navigation and intuitive UX
- **🤖 Automatic Stack Detection** - No need to specify stack! Just run `/worktree-start "feature description"`
  - Detects Rails, PHP, Node.js, Python, Go, Rust automatically based on project files
  - Smart priority system for ambiguous projects
  - Falls back to generic for unknown projects
  - Manual override still available when needed

### Previous v1.1.0 Highlights
- **📦 Extended Stack Support** - 7 stacks (rails, php, node, python, go, rust, generic)
- **🔍 Verbose Mode** - Use `-v` flag for detailed command execution
- **⚙️ Configurable Paths** - Set custom worktree locations
- **🏷️ Stack Aliases** - Use shortcuts: `js`, `ts`, `py`
- **📝 Local Config** - Per-developer settings
- **🐛 Critical Bug Fixes** - FEATURE.md generation and 6 other fixes

**[View Complete Changelog →](CHANGELOG.md)**

---

## What is This?

A set of **slash commands for Claude Code** that make working with git worktrees incredibly easy and intuitive.

**Worktrees** allow you to have multiple checkouts of the same git repository simultaneously. Instead of constantly doing stash/switch/pop, you can work on multiple features at the same time, each in its own directory.

**This system** eliminates all the complexity of manually managing worktrees, providing:

✅ Smart worktree creation with AI assistance
✅ Visual comparison of changes before merge
✅ Safe merge with automatic cleanup
✅ Frictionless management and maintenance
✅ Multi-stack support (Rails, PHP, Node.js, Python, Go, Rust, and more)
✅ Extensible configuration for custom stacks

---

## Why Use Worktrees?

### Traditional Problem

```bash
# You're working on feature A
git checkout -b feature-a
# ... making changes ...

# OH NO! Urgent bug
git stash                # Save changes
git checkout main        # Switch branch
git checkout -b hotfix   # New branch
# ... fix bug ...
git checkout feature-a   # Go back
git stash pop            # Recover changes
# Conflicts with stash! 😱
```

### Solution with Worktrees

```bash
# Terminal 1: Working on feature A
/worktree-start rails "Feature A"
cd ../feat/feature-a
# ... making changes peacefully ...

# Terminal 2: Urgent bug
/worktree-start rails "Hotfix"
cd ../hotfix/urgent-bug
# ... fix the bug ...
/worktree-merge main

# Terminal 1: Continue working without interruptions
# No stash, no conflicts, no stress ✨
```

### Key Benefits

1. **Real parallel development** - Multiple features at the same time
2. **Zero context switching** - Each feature in its own space
3. **Independent tests** - Test one feature without affecting others
4. **Uninterrupted hotfixes** - Fix bugs without touching your current work
5. **Easy code review** - Checkout colleagues' branches without stash
6. **Safe experimentation** - Try ideas without risk

---

## Installation

### Prerequisites

**Required:**
- Git 2.5+ (2.15+ recommended for best experience)
- Claude Code installed
- Existing git project

**Optional (for advanced features):**
- `jq` - Enables multi-stack support and configuration parsing
  ```bash
  # macOS
  brew install jq

  # Linux
  sudo apt-get install jq  # Debian/Ubuntu
  sudo yum install jq      # Red Hat/CentOS
  ```

### Steps

```bash
# 1. Download or clone this repository
cd /path/to/your/project

# 2. Copy the system files to your project
cp -r /path/to/worktree-commands/* .

# 3. Run the installer
chmod +x install.sh
./install.sh

# Done! Commands are available in Claude Code
```

### Verification

```bash
# In Claude Code, try:
/worktree-list

# You should see output without errors
```

### Update

```bash
# To update the commands
./install.sh

# Confirm overwrite when asked
```

---

## Quick Start

### 5 Minutes to Your First Worktree

```bash
# 1. Create worktree with AUTO-DETECTION (NEW!)
/worktree-start "Add JWT authentication with refresh tokens"
# 🔍 Detecting project stack...
# ✅ Detected stack: Ruby on Rails (rails)
# → Creates: feat/jwt-auth-refresh-tokens + FEATURE.md

# 2. Navigate and work
cd ../feat/jwt-auth-refresh-tokens
cat FEATURE.md  # Read guide generated by Claude
# ... code, commits ...

# 3. Compare before merge
/worktree-compare feat/jwt-auth-refresh-tokens

# 4. Test
bin/rails test  # Or your test command

# 5. Merge and cleanup
/worktree-merge feat/jwt-auth-refresh-tokens

# Feature complete! 🎉
```

### Most Common Commands

**Auto-detection (Recommended):**
```bash
/worktree-start "Your feature description"
```

**Manual stack (when needed):**
```bash
/worktree-start <stack> "Your feature description"
```

**Supported Stacks:**
- `rails` - Ruby on Rails (fully optimized)
- `php` - PHP projects (fully optimized - WordPress, Laravel, Symfony, etc.)
- `node`, `js`, `ts` - Node.js / JavaScript / TypeScript
- `python` or `py` - Python projects
- `go` - Go projects
- `rust` - Rust projects
- `generic` - Any other project type

> **💡 Tip:** For PHP frameworks (WordPress, Laravel, Symfony), see `.worktree-config.examples.json` for ready-to-use configurations.

**Smart Mode Features:**
- Claude analyzes your description
- Generates branch name automatically (stack-aware conventions)
- Creates `FEATURE.md` with checklist and context
- Suggests relevant files to start with

See **[STACKS_GUIDE.md](STACKS_GUIDE.md)** for detailed stack configuration.

---

## Available Commands

### `/worktree-start` - Create worktree

**Syntax:**
```bash
/worktree-start -i "feature description"       # Interactive mode (NEW! - best for beginners)
/worktree-start "feature description"          # Auto-detection mode (fast)
/worktree-start <stack> "feature description"  # Smart mode with manual stack
/worktree-start <stack> branch-name            # Manual mode
/worktree-start -v "description"               # Auto-detection with verbose mode
```

**Examples:**
```bash
# Interactive mode (guided experience - NEW!)
/worktree-start -i "Add OAuth2 authentication with Google and GitHub"
# 🎯 Interactive mode enabled
# 🔍 Detecting project stack...
# ✅ Detected stack: Ruby on Rails (rails)
#
# [Interactive prompts:]
# - Select change type (feature/bugfix/hotfix/refactor)
# - Preview and edit generated branch name
# - Confirm before creating worktree
# → Creates: feat/oauth2-auth-google-github + FEATURE.md

# Auto-detection mode (fastest!)
/worktree-start "Add OAuth2 authentication with Google and GitHub"
# 🔍 Detecting project stack...
# ✅ Detected stack: Ruby on Rails (rails)
# → Creates: feat/oauth2-auth-google-github + FEATURE.md

# Manual stack (when you need control)
/worktree-start node "Implement websocket server with Redis pub/sub"
# → Creates: feat/websocket-redis-pubsub + FEATURE.md

# Verbose mode (debugging)
/worktree-start -v "Add ML model for user recommendations"
# 🔍 Detecting project stack...
# [DEBUG] Checking stack: python
# ✅ Detected stack: Python (python)
# → Creates: feat/ml-user-recommendations + FEATURE.md

# PHP manual mode
/worktree-start php custom-widget
# → Creates: feat/custom-widget (no FEATURE.md)

# Generic project
/worktree-start generic "Add documentation"
# → Creates: feat/add-documentation + FEATURE.md
```

**What it does:**
1. Validates project type and state
2. (Smart) Claude generates appropriate branch name
3. Creates new worktree in sibling directory
4. (Smart) Generates `FEATURE.md` with complete guide
5. Setup tracking branch on remote

**[Complete documentation →](./worktree-start.md)**

---

### `/worktree-compare` - Compare before merge

**Syntax:**
```bash
/worktree-compare [target-branch]  # Default: main/master auto-detect
```

**Examples:**
```bash
# Compare with main
/worktree-compare

# Compare with develop
/worktree-compare develop
```

**What it shows:**
- 📊 Change summary (files, +lines, -lines)
- 📝 Commit list
- ⚠️ Detection of potential conflicts
- 📋 Full diff for review

**[Complete documentation →](./worktree-compare.md)**

---

### `/worktree-merge` - Merge and cleanup

**Syntax:**
```bash
/worktree-merge [target-branch]  # Default: main/master auto-detect
```

**Example:**
```bash
/worktree-merge main
```

**What it does (all automatic):**
1. ✅ Validates state (uncommitted changes check)
2. 🔀 Merge to target branch
3. ⬆️ Push to remote
4. 🗑️ Remove worktree directory
5. 🌿 Delete local/remote branch
6. 📍 Leaves you in main branch

**⚠️ IMPORTANT:** Always use `/worktree-compare` before merge.

**[Complete documentation →](./worktree-merge.md)**

---

### `/worktree-list` - List and manage

**Syntax:**
```bash
/worktree-list              # List active worktrees
/worktree-list cleanup      # Remove merged worktrees
/worktree-list prune        # Clean stale references
```

**Examples:**
```bash
# View current state
/worktree-list

# Cleanup after merges
/worktree-list cleanup

# Clean orphaned references
/worktree-list prune
```

**[Complete documentation →](./worktree-list.md)**

---

## Complete Documentation

### By Level

| Document | Audience | Reading Time |
|-----------|-----------|----------------|
| [`START_HERE.md`](./START_HERE.md) | **Beginners** | 5 min |
| [`CHEATSHEET.md`](./CHEATSHEET.md) | **Quick reference** | 2 min |
| `README.md` (this file) | **General overview** | 10 min |

### By Command

| Command | Documentation | Level |
|---------|---------------|-------|
| `/worktree-start` | [`worktree-start.md`](./worktree-start.md) | 📘 Detailed |
| `/worktree-compare` | [`worktree-compare.md`](./worktree-compare.md) | 📘 Detailed |
| `/worktree-merge` | [`worktree-merge.md`](./worktree-merge.md) | 📘 Detailed |
| `/worktree-list` | [`worktree-list.md`](./worktree-list.md) | 📘 Detailed |

---

## Workflows

### Workflow 1: Normal Feature

```bash
# 1. Create worktree
/worktree-start rails "Add two-factor authentication"
cd ../feat/two-factor-auth

# 2. Work
# ... code, commits ...

# 3. Review
/worktree-compare main
bin/rails test

# 4. Merge
/worktree-merge main
```

**Typical time:** 1-3 days
**Complexity:** Normal

---

### Workflow 2: Urgent Hotfix

```bash
# While working on feature (Terminal 1)
cd ../feat/big-feature

# Hotfix (Terminal 2 - new)
cd /path/to/project
/worktree-start rails "Hotfix: Critical login bug"
cd ../hotfix/critical-login-bug
# ... quick fix ...
/worktree-merge main

# Terminal 1: Continue working without interruptions
```

**Typical time:** 30 min - 2 hours
**Complexity:** High urgency, low complexity

---

### Workflow 3: Parallel Development

```bash
# Terminal 1: Feature A (large, takes days)
/worktree-start rails "Complete dashboard redesign"
cd ../feat/dashboard-redesign

# Terminal 2: Feature B (small, takes hours)
/worktree-start rails "Add PDF export button"
cd ../feat/pdf-export-button

# Terminal 2: Finish B first
/worktree-merge main

# Terminal 1: Continue with A
# When done:
/worktree-merge main
```

**Typical time:** Variable
**Complexity:** High (multiple management)

---

### Workflow 4: Experimentation

```bash
# Test new idea without commitment
/worktree-start rails "Experiment: React components instead of Hotwire"
cd ../feat/experiment-react-components

# Experiment...
# ... doesn't work well ...

# Abandon without consequences
cd /path/to/project
rm -rf ../feat/experiment-react-components
/worktree-list prune

# Main project unaffected
```

**Typical time:** Variable (abandon OK)
**Complexity:** Low (safe to fail)

---

### Workflow 5: Code Review

```bash
# Colleague requests review of their branch
/worktree-start rails colleague-feature-branch
cd ../colleague-feature-branch

# Local review
# ... read code, run tests ...

# No merge, just review
cd /path/to/project
rm -rf ../colleague-feature-branch
/worktree-list prune
```

**Typical time:** 30 min - 1 hour
**Complexity:** Low

---

## Best Practices

### 1. Always Use Smart Mode

**❌ Avoid:**
```bash
/worktree-start rails user-auth
```

**✅ Prefer:**
```bash
/worktree-start rails "Add JWT authentication with refresh token support"
```

**Why:** Claude generates better branch name, creates useful guide, suggests files.

---

### 2. ALWAYS Compare Before Merge

**❌ Dangerous:**
```bash
/worktree-merge main  # Without reviewing
```

**✅ Safe:**
```bash
/worktree-compare main  # Careful review
bin/rails test          # Tests pass
/worktree-merge main    # Then merge
```

---

### 3. Short Features (<3 days)

**❌ Long branch:**
- 2 weeks of development
- Many potential conflicts
- Difficult review

**✅ Short branch:**
- 1-3 days of development
- Frequent merge
- Minimal conflicts
- Easy review

---

### 4. Separate Terminal/IDE per Worktree

**❌ Confusing:**
```bash
cd ../worktree-a
# work...
cd ../worktree-b
# where am I?
```

**✅ Clear:**
- Terminal 1: worktree-a
- Terminal 2: worktree-b
- Each in its own space

---

### 5. Regular Cleanup

```bash
# Every Friday
/worktree-list cleanup
/worktree-list prune
```

**Keeps workspace clean and organized.**

---

### 6. Tests Before Merge

```bash
# Rails
bin/rails test
bundle exec rubocop

# PHP
npm run build
vendor/bin/phpunit  # if configured
```

**Don't merge if tests fail.**

---

### 7. Clear Commit Messages

**❌ Bad:**
```
git commit -m "changes"
git commit -m "fix"
git commit -m "WIP"
```

**✅ Good:**
```
git commit -m "[feat] Add JWT token generation"
git commit -m "[fix] Correct token expiration logic"
git commit -m "[test] Add integration tests for auth flow"
```

---

## FAQ

### General

**Q: How many worktrees can I have?**
A: Technically unlimited, but recommended 2-3 maximum to avoid confusion.

**Q: Do worktrees share the same .git?**
A: Yes, all point to the same repository with different checkouts.

**Q: Does it affect my main project?**
A: No, each worktree is completely independent.

**Q: Can I push from a worktree?**
A: Yes, it works exactly like a normal branch.

**Q: What happens if I manually delete a worktree?**
A: Git keeps references. Use `/worktree-list prune` to clean up.

---

### Smart Mode vs Manual

**Q: When to use smart mode?**
A: Whenever the feature takes >1 hour. Claude generates useful context.

**Q: When to use manual mode?**
A: Quick fixes (<30 min) where you don't need AI assistance.

**Q: Does Claude always generate good names?**
A: 90% of the time yes. If you don't like it, you can edit the branch name later.

---

### Common Problems

**Q: "Branch already exists" error?**
A: You already have a worktree with that name. Use `/worktree-list` to verify.

**Q: "Uncommitted changes" when merging?**
A: Commit your changes first: `git add . && git commit -m "msg"`

**Q: How to resolve merge conflicts?**
A: Manually: open files, resolve <<<<<<, git add, git commit.

**Q: Worktree won't delete?**
A: Close all terminals/IDEs using that directory first.

---

### Performance

**Q: Do worktrees consume a lot of space?**
A: No, they share the .git directory. Only working tree files are duplicated.

**Q: Is it slower than normal branches?**
A: No, performance is identical.

---

### Teams

**Q: Does it work with teams?**
A: Yes, each developer manages their own worktrees locally.

**Q: Should I commit .claude/?**
A: No, install.sh automatically adds it to .gitignore.

**Q: Can I use it with Pull Requests?**
A: Yes, push your branch normally and create PR. Then `/worktree-list cleanup`.

---

## Troubleshooting

### Problem: Commands don't appear in Claude Code

**Solution:**
```bash
# Verify installation
ls .claude/commands/

# Reinstall
./install.sh
```

---

### Problem: "Not in a worktree" error

**Cause:** Running command from main repo

**Solution:**
```bash
cd ../your-feature-branch
/worktree-compare main
```

---

### Problem: Merge conflicts

**Cause:** Files modified in both branches

**Solution:**
```bash
# Git pauses the merge
# 1. Open files with <<<<<<<
# 2. Resolve manually
# 3. git add <resolved-files>
# 4. git commit
# 5. git push origin main
# 6. Manual cleanup of worktree
```

---

### Problem: Worktree directory won't delete

**Cause:** IDE/terminal using the directory

**Solution:**
```bash
# Close all windows/terminals
# Then:
git worktree remove /path/to/worktree --force

# Or manually:
rm -rf /path/to/worktree
/worktree-list prune
```

---

### Problem: Branch won't delete

**Cause:** Branch has unmerged commits

**Solution:**
```bash
# See which commits aren't merged
git log main..your-branch

# Force delete if you're sure
git branch -D your-branch
```

---

### Problem: "Permission denied" in install.sh

**Solution:**
```bash
chmod +x install.sh
./install.sh
```

---

## Stack-Specific Notes

### Rails Projects

**Naming conventions:**
- `feat/*` - New feature
- `fix/*` - Bug fix
- `refactor/*` - Refactoring
- `test/*` - Tests
- `chore/*` - Maintenance

**Pre-merge checklist:**
- [ ] `bin/rails test` → Pass
- [ ] `bundle exec rubocop` → No offenses
- [ ] Migrations included and reversible
- [ ] Schema.rb updated
- [ ] No `binding.pry` in code

**Common directories:**
- `app/models/`
- `app/controllers/`
- `db/migrate/`
- `spec/` or `test/`
- `config/routes.rb`

---

### PHP Projects

**Naming conventions:**
- `feat/*` - New feature (default)
- `fix/*` - Bug fix
- `refactor/*` - Refactoring
- `hotfix/*` - Critical fix

> **Note:** PHP projects can be customized per framework. See `.worktree-config.examples.json` for WordPress, Laravel, Symfony configurations.

**Pre-merge checklist:**
- [ ] `composer install` → Dependencies updated
- [ ] Tests pass → `vendor/bin/phpunit` or framework test command
- [ ] No debug code (`var_dump()`, `dd()`, etc.)
- [ ] Assets compiled (if applicable)
- [ ] `composer.lock` updated if `composer.json` changed

**Common directories:**
- `src/` or `app/` - Application code
- `tests/` - Test files
- `public/` - Public assets
- Framework-specific directories

---

## Advanced Topics

### Multiple Repositories

If you work with multiple projects:

```bash
# Project A
cd ~/projects/project-a
./install.sh

# Project B
cd ~/projects/project-b
./install.sh

# Each has its own worktrees
# Completely independent
```

---

### Custom Configurations

**Per-Developer Local Settings (New in v1.1.0):**

```bash
# Create local configuration (not committed)
cp .worktree-config.local.json.example .worktree-config.local.json

# Edit your personal settings
nano .worktree-config.local.json
```

**Example local config:**
```json
{
  "defaults": {
    "worktree_base": "/Users/yourname/worktrees",  // Custom location
    "auto_push": false                              // Disable auto-push
  },
  "stacks": {
    "custom-stack": {
      "name": "My Custom Stack",
      "branch_prefix": "feature"
    }
  }
}
```

**Edit commands directly:**

```bash
# Commands are in:
.claude/commands/worktree-*.md

# You can customize:
# - Branch naming conventions
# - Pre-merge checks
# - Output format
# - Etc.
```

---

### Integration with CI/CD

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: bin/rails test

      # Worktrees are transparent to CI
      # No special configuration required
```

---

## Languages

This project is fully documented in multiple languages:

### 🇬🇧 English (Current)
Complete documentation in the root directory:
- [README.md](README.md) - Main documentation
- [START_HERE.md](START_HERE.md) - Quick start guide
- [CHEATSHEET.md](CHEATSHEET.md) - Quick reference
- [STACKS_GUIDE.md](STACKS_GUIDE.md) - Multi-stack guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- And more...

### 🇪🇸 Español
Documentación completa en la carpeta `es/`:
- [es/README.md](es/README.md) - Documentación principal
- [es/START_HERE.md](es/START_HERE.md) - Guía de inicio rápido
- [es/CHEATSHEET.md](es/CHEATSHEET.md) - Referencia rápida
- [es/STACKS_GUIDE.md](es/STACKS_GUIDE.md) - Guía de múltiples stacks
- [es/CONTRIBUTING.md](es/CONTRIBUTING.md) - Guía de contribución
- Y más...

**Want to contribute translations?** See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines!

---

## Contributing

### Report Bugs

Open an issue with:
- Problem description
- Steps to reproduce
- Complete error output
- Git version: `git --version`
- Operating system

---

### Suggest Features

Open an issue with:
- Feature description
- Use case
- Example of how it would work

---

### Pull Requests

1. Fork the repository
2. Create feature branch (use these worktree commands! 😉)
3. Make changes
4. Tests pass
5. Submit PR

---

## Roadmap

### v1.2 (Next)

- [ ] Automatic stack detection based on project files
- [ ] Interactive mode for worktree-start
- [ ] Visual diff tool integration
- [ ] Better conflict resolution workflow
- [ ] Additional framework-specific optimizations (Django, Express, FastAPI)

### v1.3 (Future)

- [ ] Web UI for worktree management
- [ ] Metrics and analytics
- [ ] Team collaboration features
- [ ] Integration with popular project management tools

---

## License

MIT License - See [`LICENSE`](./LICENSE) for details.

---

## Acknowledgments

- Created for Claude Code by Alex
- Inspired by frustration with stash/switch workflows
- Thanks to the Git community for the worktree concept

---

## Support

**Need help?**
1. Read [`START_HERE.md`](./START_HERE.md) first
2. Check [`CHEATSHEET.md`](./CHEATSHEET.md) for quick reference
3. Review this README
4. Search in [FAQ](#faq) and [Troubleshooting](#troubleshooting) sections
5. Open an issue if you still have problems

---

## Final Notes

**This system is designed to make your life easier, not more complicated.**

If you find the commands confusing or they don't work as expected, it's a bug - please report.

The goal is for you to use worktrees without thinking about the underlying complexity. If you have to read git documentation to understand what a command does, we've failed.

**Happy parallel development! 🚀**

---

*Last updated: November 2025*
*Version: 1.0.0*
