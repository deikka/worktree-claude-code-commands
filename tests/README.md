# Tests

This directory contains tests for the installation script and command functionality.

## Running Tests

### Quick Test

```bash
bash tests/test-install.sh
```

### Manual Test

If the automated test fails, you can test manually:

```bash
# 1. Create a test repository
cd /tmp
mkdir test-repo
cd test-repo
git init
git config user.name "Test"
git config user.email "test@test.com"
echo "test" > README.md
git add . && git commit -m "Initial"

# 2. Run installation
bash /path/to/worktree-claude-code-commands/install.sh

# 3. Verify
ls -la .claude/commands/
cat .gitignore
```

## Test Coverage

Current tests cover:

- ✅ install.sh existence
- ✅ Bash syntax validation
- ✅ Required command files existence
- ✅ Installation process
- ✅ Directory creation (.claude/commands/)
- ✅ File copying
- ✅ .gitignore update
- ✅ YAML frontmatter validation
- ✅ Re-installation/overwrite

## Future Tests

Planned tests to add:

- [ ] Command execution tests (requires Claude Code)
- [ ] Worktree creation validation
- [ ] Branch naming conventions
- [ ] Merge process
- [ ] Cleanup process
- [ ] Error handling scenarios
- [ ] Cross-platform compatibility (macOS, Linux)

## CI Integration

Tests are automatically run on:
- Every push to main/develop
- Every pull request
- Via GitHub Actions (see `.github/workflows/ci.yml`)

## Troubleshooting

### Test fails on macOS

Some bash features may differ. Ensure you're using bash 4+:

```bash
bash --version
```

### Test fails on Linux

Check git version:

```bash
git --version
```

Minimum required: git 2.17+

### Permission errors

Make test script executable:

```bash
chmod +x tests/test-install.sh
```
