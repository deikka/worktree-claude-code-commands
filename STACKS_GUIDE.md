# Stack Configuration Guide

This guide explains how to use worktree commands with different technology stacks and how to add support for new ones.

---

## Supported Stacks

Out of the box, the system supports:

### Optimized Support (Full Features)

- **Rails** - Ruby on Rails with full Rails-specific checks
- **PHP** - PHP projects (vanilla, Laravel, Symfony, WordPress, etc.)

### Built-in Support (Standard Features)

- **Node.js** - JavaScript/TypeScript projects
- **Python** - Python projects
- **Go** - Go projects
- **Rust** - Rust projects
- **Generic** - Any other project type

> **💡 Tip:** For PHP-based frameworks (WordPress, Laravel, Symfony), see `.worktree-config.examples.json` for ready-to-use configurations you can copy to your project.

---

## Using Different Stacks

### Syntax

```bash
/worktree-start <stack> "feature description"
```

### Examples

```bash
# Rails project
/worktree-start rails "Add user authentication"
# Creates: feat/user-authentication

# PHP project
/worktree-start php "Add contact form"
# Creates: feat/contact-form

# Node.js project
/worktree-start node "Implement websocket server"
# Creates: feat/websocket-server

# Python project
/worktree-start python "Add ML model training"
# Creates: feat/ml-model-training

# Go project
/worktree-start go "Optimize database queries"
# Creates: feat/optimize-db-queries

# Generic project
/worktree-start generic "New feature"
# Creates: feat/new-feature
```

### Aliases

You can use short forms:

```bash
/worktree-start js "feature"      # Same as 'node'
/worktree-start ts "feature"      # Same as 'node'
/worktree-start py "feature"      # Same as 'python'
```

---

## Stack-Specific Features

### Rails (Fully Optimized)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`
- Refactors: `refactor/*`
- Hotfixes: `hotfix/*`

**Automatic checks:**
- ✅ Database migrations detection
- ✅ Route conflicts
- ✅ Credentials validation
- ✅ Test coverage

**FEATURE.md includes:**
- Models, controllers, views structure
- Migration steps
- Test requirements
- Security considerations

### PHP (Fully Optimized)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`
- Refactors: `refactor/*`
- Hotfixes: `hotfix/*`

**Automatic checks:**
- ✅ Dependency management (Composer)
- ✅ Syntax validation
- ✅ Test structure
- ✅ Framework-specific checks (when configured)

**FEATURE.md includes:**
- File structure suggestions
- Dependencies to consider
- Testing approach
- Framework-specific guidelines (when configured)

**Common PHP configurations available in `.worktree-config.examples.json`:**
- WordPress with WordPlate
- WordPress vanilla
- Laravel
- Symfony
- Generic PHP

### Node.js (Standard Support)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Automatic checks:**
- ✅ package.json changes
- ✅ Dependency conflicts
- ✅ Build validation

**FEATURE.md includes:**
- File structure suggestions
- Dependencies to consider
- Testing approach

### Python (Standard Support)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Automatic checks:**
- ✅ requirements.txt changes
- ✅ Import validation
- ✅ Test structure

**FEATURE.md includes:**
- Module structure
- Dependencies
- Testing approach

### Go (Standard Support)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Automatic checks:**
- ✅ go.mod changes
- ✅ Build validation
- ✅ Test coverage

**FEATURE.md includes:**
- Package structure
- Interface design
- Testing approach

### Rust (Standard Support)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`

**Automatic checks:**
- ✅ Cargo.toml changes
- ✅ Clippy warnings
- ✅ Test coverage

**FEATURE.md includes:**
- Module structure
- Ownership considerations
- Testing approach

### Generic (Basic Support)

**Branch conventions:**
- Features: `feat/*`
- Bugfixes: `fix/*`
- Docs: `docs/*`
- Tests: `test/*`

**Automatic checks:**
- ✅ Basic git validation only

**FEATURE.md includes:**
- Generic implementation guide
- File organization tips
- Testing reminders

---

## Configuration Files

### System Configuration

Stack behaviors are defined in `.worktree-config.json`. This file is included with the system and defines:

- Branch naming conventions
- Stack-specific checks
- File suggestions for FEATURE.md
- Default behaviors

### PHP Framework Examples

The `.worktree-config.examples.json` file contains ready-to-use configurations for popular PHP frameworks and CMSs:

- **WordPress with WordPlate** - Modern WordPress development
- **WordPress Vanilla** - Standard WordPress installation
- **Laravel** - Laravel framework projects
- **Symfony** - Symfony framework projects
- **Generic PHP** - Standard PHP projects

To use these configurations, copy the relevant section to your project's `.worktree-config.local.json` file. See the examples file for detailed instructions.

### Example Configuration Entry

```json
{
  "stacks": {
    "python": {
      "name": "Python",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix",
        "refactor": "refactor"
      },
      "checks": [
        "dependencies",
        "tests",
        "linting"
      ],
      "suggested_files": [
        "src/**/*.py",
        "tests/**/*.py",
        "requirements.txt"
      ]
    }
  }
}
```

---

## Customizing for Your Project

### Option 1: Create Local Override

Create `.worktree-config.local.json` in your project root:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "feature",
      "branch_patterns": {
        "feature": "feature",
        "bugfix": "bugfix"
      }
    }
  }
}
```

This will override the default Rails configuration for your project only.

### Option 2: Add Custom Stack

Create `.worktree-config.local.json`:

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
      "checks": [
        "dependencies",
        "tests",
        "build"
      ],
      "suggested_files": [
        "lib/**/*.dart",
        "test/**/*.dart",
        "pubspec.yaml"
      ]
    }
  }
}
```

Then use it:

```bash
/worktree-start flutter "Add authentication screen"
```

---

## Adding Full Support for New Stacks

To add comprehensive support for a new stack (with all optimizations):

### 1. Define Configuration

Add to `.worktree-config.json` or create local override:

```json
{
  "stacks": {
    "your-stack": {
      "name": "Your Stack Name",
      "branch_prefix": "feat",
      "branch_patterns": {
        "feature": "feat",
        "bugfix": "fix"
      },
      "checks": [
        "your-specific-checks"
      ],
      "suggested_files": [
        "path/to/**/*.ext"
      ]
    }
  }
}
```

### 2. Update Command Files (Optional)

For deep integration, add stack-specific logic to command files:

**In `worktree-start.md`:**

```bash
# Add your stack to validation
if [[ "$STACK" == "your-stack" ]]; then
  echo "🎯 Your Stack project detected"
  # Add specific setup...
fi
```

**In `worktree-compare.md`:**

```bash
# Add your stack-specific checks
if [[ "$STACK" == "your-stack" ]]; then
  echo "🔧 YOUR-STACK-SPECIFIC CHECKS"
  # Add checks...
fi
```

### 3. Document It

Add documentation to `STACKS_GUIDE.md` (this file) with:
- Branch conventions
- Automatic checks
- FEATURE.md content
- Examples

### 4. Contribute Back

If you add support for a popular stack, consider:
1. Testing thoroughly
2. Creating a PR to add it to the main project
3. Adding examples and documentation

---

## Stack Detection (Future Feature)

In future versions, we may add automatic stack detection:

```bash
# Automatically detects stack from project files
/worktree-start auto "feature description"

# Detection logic:
# - Gemfile + config/application.rb → Rails
# - package.json + node_modules → Node
# - requirements.txt + *.py → Python
# - go.mod → Go
# - Cargo.toml → Rust
# - wp-config.php → WordPress
```

---

## Best Practices

### 1. Choose the Right Stack Type

- Use **specific stack** (rails, node, python) when available
- Use **generic** only for non-standard projects
- Create **custom stack** for repeated use

### 2. Maintain Consistency

Within a project, always use the same stack identifier:

```bash
# Good - consistent
/worktree-start node "Feature A"
/worktree-start node "Feature B"

# Bad - inconsistent
/worktree-start node "Feature A"
/worktree-start generic "Feature B"
```

### 3. Document Custom Stacks

If you create custom stacks, document them in your project's README:

```markdown
## Worktree Commands

This project uses custom worktree configuration:

\`\`\`bash
# Use 'flutter' stack for this project
/worktree-start flutter "feature description"
\`\`\`
```

---

## Examples by Use Case

### Monorepo with Multiple Stacks

```bash
# Backend (Node.js)
/worktree-start node "Add GraphQL API"

# Frontend (React)
/worktree-start node "Add user dashboard"

# Mobile (would need custom stack)
/worktree-start flutter "Add login screen"
```

### Microservices

```bash
# Service A (Go)
/worktree-start go "Add authentication service"

# Service B (Python)
/worktree-start python "Add ML prediction service"

# Service C (Rust)
/worktree-start rust "Add high-performance cache"
```

### Full-Stack Project

```bash
# Backend Rails API
/worktree-start rails "Add JWT authentication"

# Frontend Next.js
/worktree-start node "Add login UI"

# Shared Documentation
/worktree-start generic "Update API docs"
```

---

## Troubleshooting

### "Unknown stack" error

If you get an error about unknown stack:

1. Check spelling: `rails` not `rail`, `node` not `nodejs`
2. Use `generic` as fallback: `/worktree-start generic "feature"`
3. Create custom stack configuration

### Branch naming doesn't match expectations

Override in `.worktree-config.local.json`:

```json
{
  "stacks": {
    "rails": {
      "branch_prefix": "your-prefix"
    }
  }
}
```

### Missing stack-specific checks

This is normal for built-in stacks (node, python, etc.). To add more checks:

1. Create custom configuration
2. Or contribute to the main project with enhanced support

---

## Contributing New Stacks

We welcome contributions for new stack support! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- How to propose new stacks
- Testing requirements
- Documentation standards
- Pull request process

**Priority stacks for contributions:**
- Swift/iOS development
- Kotlin/Android development
- C#/.NET
- Java/Spring
- PHP (non-WordPress)
- Elixir/Phoenix

---

## Reference

### Complete Stack List

| Stack      | Aliases    | Branch Prefix | Status              |
|------------|------------|---------------|---------------------|
| rails      | -          | feat          | ✅ Fully Optimized  |
| php        | -          | feat          | ✅ Fully Optimized  |
| node       | js, ts     | feat          | ✅ Built-in Support |
| python     | py         | feat          | ✅ Built-in Support |
| go         | golang     | feat          | ✅ Built-in Support |
| rust       | rs         | feat          | ✅ Built-in Support |
| generic    | -          | feat          | ✅ Basic Support    |

> **Note:** PHP stack can be customized for specific frameworks (WordPress, Laravel, Symfony) using configurations from `.worktree-config.examples.json`

### Configuration Priority

1. `.worktree-config.local.json` (project-specific, highest priority)
2. `.worktree-config.json` (system defaults)
3. Hard-coded fallbacks in commands (lowest priority)

---

Need help? [Open an issue](https://github.com/deikka/worktree-claude-code-commands/issues) or check [README.md](README.md) for more information.
