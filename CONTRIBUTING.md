# Contributing to Claude Code Worktree Commands

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

By participating in this project, you agree to:
- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Prioritize the community's well-being

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear description** of the issue
- **Steps to reproduce** the behavior
- **Expected behavior** vs what actually happened
- **Environment details**: OS, Git version, Claude Code version
- **Screenshots** if applicable

Use the bug report template when creating issues.

### Suggesting Enhancements

Enhancement suggestions are welcome! Please:

- Use a clear and descriptive title
- Provide a detailed description of the suggested enhancement
- Explain why this enhancement would be useful
- Provide examples of how it would work

Use the feature request template when creating issues.

### Code Contributions

#### Development Setup

1. **Fork the repository**
   ```bash
   # Fork via GitHub UI, then clone your fork
   git clone https://github.com/YOUR-USERNAME/worktree-claude-code-commands.git
   cd worktree-claude-code-commands
   ```

2. **Create a test environment**
   ```bash
   # Create a test git repo to try commands
   cd /tmp
   mkdir test-repo
   cd test-repo
   git init
   echo "# Test" > README.md
   git add . && git commit -m "Initial commit"
   ```

3. **Install commands locally**
   ```bash
   # Copy to test repo
   mkdir -p .claude/commands
   cp /path/to/worktree-claude-code-commands/worktree-*.md .claude/commands/
   ```

4. **Test your changes** using Claude Code in the test repository

#### Making Changes

1. **Create a feature branch** from `main`
   ```bash
   git checkout -b feat/your-feature-name
   ```

2. **Make your changes**
   - Follow existing code style and conventions
   - Keep changes focused and atomic
   - Write clear, descriptive commit messages

3. **Test thoroughly**
   - Test all four slash commands
   - Test edge cases and error conditions
   - Test on multiple stacks (Rails, PHP, Node, etc.) if applicable

4. **Update documentation**
   - Update README.md if adding features
   - Update CHEATSHEET.md for new workflows
   - Add comments in command files for complex logic

#### Commit Message Guidelines

Use conventional commit format:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code restructuring without behavior change
- `test`: Adding missing tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(worktree-start): add support for custom base branch

fix(worktree-merge): prevent deletion of main branch

docs(readme): clarify installation steps for Windows users
```

#### Pull Request Process

1. **Update your branch** with latest main
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Push to your fork**
   ```bash
   git push origin feat/your-feature-name
   ```

3. **Create Pull Request**
   - Use a clear, descriptive title
   - Fill out the PR template completely
   - Link related issues using keywords (Fixes #123)
   - Request review from maintainers

4. **Respond to feedback**
   - Address all review comments
   - Push additional commits if needed
   - Mark conversations as resolved

5. **Squash and merge** (maintainers will handle this)

### Improving Documentation

Documentation improvements are highly valuable! You can help by:

- Fixing typos or unclear language
- Adding examples for common use cases
- Translating docs to other languages
- Adding diagrams or visual aids
- Improving error messages

### Adding Stack Support

Currently fully supports Rails and PHP (with framework variants). To add support for another stack:

1. **Study existing implementations** in `.worktree-config.json` and command files
2. **Identify stack-specific patterns** (naming, structure, tools)
3. **Add configuration** to `.worktree-config.json`
4. **Add conditional logic** to commands (if needed for advanced features)
5. **Update documentation** with new examples in STACKS_GUIDE.md
6. **Test thoroughly** with real projects

For PHP framework variants, see `.worktree-config.examples.json` for reference.

## Project Structure

```
worktree-claude-code-commands/
├── install.sh              # Installation script
├── worktree-start.md       # Command: Create worktree
├── worktree-list.md        # Command: List worktrees
├── worktree-compare.md     # Command: Compare changes
├── worktree-merge.md       # Command: Merge and cleanup
├── README.md               # Main documentation
├── START_HERE.md           # Quick start guide
├── CHEATSHEET.md           # Quick reference
├── MANIFEST.md             # Project inventory
├── LICENSE                 # MIT License
└── CONTRIBUTING.md         # This file
```

## Command File Structure

Each slash command file follows this structure:

```markdown
---
description: Short description for Claude Code
allowed-tools: [bash_tool]
---

# Command Title

Brief explanation of what the command does.

**Usage:** `/command-name [args]`

## Validation
Pre-flight checks before execution

## Process
Step-by-step execution logic

### 1. Step Name
Bash code blocks with detailed comments

### 2. Next Step
...

## Error Handling
How to handle various error conditions

## Rollback
How to undo if something goes wrong
```

## Style Guidelines

### Bash Code

- Use `#!/usr/bin/env bash` shebang (if standalone scripts)
- Quote all variable expansions: `"$VARIABLE"`
- Use `[[ ]]` for conditionals instead of `[ ]`
- Check exit codes: `if [ $? -ne 0 ]; then`
- Add error handling for all critical operations
- Use descriptive variable names in UPPER_CASE

### Documentation

- Use clear, concise language
- Include practical examples
- Format code blocks with appropriate language tags
- Use emojis sparingly and meaningfully (✅ ❌ 🚀 💡)
- Keep line length under 100 characters

### Markdown

- Use ATX headers (#) not Setext (underlines)
- Leave blank lines around headers and code blocks
- Use fenced code blocks (```) with language tags
- Use reference-style links for repeated URLs

## Testing Checklist

Before submitting a PR, verify:

- [ ] All commands work in test environment
- [ ] Error handling works correctly
- [ ] Documentation is updated
- [ ] Commit messages follow convention
- [ ] No sensitive information in commits
- [ ] Code is commented where complex
- [ ] Examples are tested and work
- [ ] Links in docs are valid

## Getting Help

- **Questions?** Open a GitHub Discussion
- **Stuck?** Comment on your PR for help
- **Not sure?** Open a draft PR early for feedback

## Recognition

Contributors will be:
- Listed in README.md contributors section
- Mentioned in release notes
- Credited in commit history

Thank you for making this project better! 🙏

---

**Remember:** Good contributions don't have to be big. Fixing typos, improving docs, or adding examples are all valuable!
