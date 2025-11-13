# Multi-Stack Support Upgrade

This document explains the multi-stack support added to the Git Worktrees for Claude Code system.

## What Changed?

The system now supports **multiple technology stacks** beyond just Rails and WordPress:

### Previously (v1.0.0-alpha)
```bash
# Only supported:
/worktree-start rails "feature"
/worktree-start wp "feature"
```

### Now (v1.0.0)
```bash
# Fully optimized support:
/worktree-start rails "feature"
/worktree-start wordpress "feature"

# Built-in support:
/worktree-start node "feature"
/worktree-start python "feature"
/worktree-start go "feature"
/worktree-start rust "feature"

# Generic fallback:
/worktree-start generic "feature"

# Extensible:
# Add your own stack configurations!
```

## New Features

### 1. Configuration System

**File:** `.worktree-config.json`

Defines stack-specific behaviors:
- Branch naming conventions
- Stack-specific checks
- Suggested files for FEATURE.md
- Default behaviors

### 2. Local Overrides

**File:** `.worktree-config.local.json` (optional)

Override default configurations for your project:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "feature"
    }
  }
}
```

### 3. Custom Stacks

Add your own stack support:

```json
{
  "stacks": {
    "flutter": {
      "name": "Flutter",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix"
      },
      "checks": ["dependencies", "tests", "build"],
      "suggested_files": ["lib/**/*.dart", "test/**/*.dart"]
    }
  }
}
```

Then use it:
```bash
/worktree-start flutter "Add authentication screen"
```

## Migration Guide

### If You Used Rails

**No changes needed!** Your existing usage continues to work:

```bash
/worktree-start rails "feature description"
```

### If You Used WordPress

**Minor change:** Use `wordpress` instead of `wp` (though `wp` still works as alias):

```bash
# Both work:
/worktree-start wordpress "feature"
/worktree-start wp "feature"  # Alias
```

### If You Want to Use Other Stacks

Simply use the new stack names:

```bash
/worktree-start node "feature"
/worktree-start python "feature"
/worktree-start go "feature"
/worktree-start rust "feature"
/worktree-start generic "feature"  # For anything else
```

## Benefits

### 1. Wider Adoption

The system is no longer limited to Rails/WordPress developers. Anyone can use it!

### 2. Smart Conventions

Each stack gets appropriate branch naming:
- Rails: `feat/*`, `fix/*`, `refactor/*`
- WordPress: `feature/*`, `bugfix/*`, `enhancement/*`
- Node/Python/Go/Rust: `feat/*`, `fix/*`
- Generic: `feat/*`, `fix/*`, `docs/*`, `test/*`

### 3. Stack-Specific Checks

Comparisons include relevant checks:
- Rails: Migrations, routes, credentials
- WordPress: Themes, plugins, assets
- Node: Dependencies, build
- Python: Dependencies, imports
- Go: Dependencies, build
- Rust: Dependencies, clippy

### 4. Extensibility

Add support for YOUR stack without modifying core files:

```bash
# 1. Create .worktree-config.local.json
# 2. Add your stack definition
# 3. Use it immediately!
```

## Documentation

- **[STACKS_GUIDE.md](STACKS_GUIDE.md)** - Complete guide to all stacks
- **[README.md](README.md)** - Updated with multi-stack examples
- **[.worktree-config.json](.worktree-config.json)** - Default configurations

## Backward Compatibility

**100% compatible** with existing usage:

- All Rails commands work exactly as before
- All WordPress commands work exactly as before
- FEATURE.md generation unchanged for Rails/WordPress
- No configuration required for existing users

## What's Next?

### Immediate (v1.0.0)
- [x] Multi-stack support
- [x] Configuration system
- [x] Documentation

### Future (v1.1.0+)
- [ ] Automatic stack detection
- [ ] More optimized stacks (Swift, Kotlin, Elixir, etc.)
- [ ] Team-wide configuration sharing
- [ ] Stack templates marketplace

## Questions?

- See [STACKS_GUIDE.md](STACKS_GUIDE.md) for detailed usage
- See [.worktree-config.json](.worktree-config.json) for configuration examples
- Open an [issue](https://github.com/deikka/worktree-claude-code-commands/issues) if you need help

---

**This makes the system useful for ANY developer, not just Rails/WordPress devs!** 🎉
