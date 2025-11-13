# Example Project Setup

This directory provides instructions for testing the worktree commands with a real project.

## Quick Start: Rails Demo

Create a minimal Rails app to test the commands:

```bash
# 1. Create a new Rails app
rails new demo-app --minimal
cd demo-app

# 2. Initialize git
git init
git add .
git commit -m "Initial commit"

# 3. Install worktree commands
bash <(curl -sSL https://raw.githubusercontent.com/yourusername/worktree-claude-code-commands/main/install.sh)

# Or locally:
# bash /path/to/worktree-claude-code-commands/install.sh

# 4. Verify installation
ls -la .claude/commands/

# 5. Test the commands!
/worktree-start rails "Add user authentication"
```

## Alternative: WordPress Demo

For WordPress projects using WordPlate:

```bash
# 1. Create WordPlate project
composer create-project wordplate/wordplate demo-wp
cd demo-wp

# 2. Initialize git
git init
git add .
git commit -m "Initial commit"

# 3. Install worktree commands
bash /path/to/worktree-claude-code-commands/install.sh

# 4. Test the commands
/worktree-start wp "Add contact form"
```

## Testing Workflow

Once you have a project set up, follow this workflow to test all commands:

### 1. Create a Worktree (Smart Mode)

```bash
/worktree-start rails "Add JWT authentication with refresh tokens"
```

**Expected outcome:**
- New worktree created at `../feat/jwt-authentication-refresh`
- `FEATURE.md` file generated with implementation guide
- Branch tracking set up correctly

**Verify:**
```bash
git worktree list
cd ../feat/jwt-authentication-refresh
ls -la
cat FEATURE.md
```

### 2. Make Some Changes

```bash
# In the worktree directory
cd ../feat/jwt-authentication-refresh

# Create some files
echo "class JwtService; end" > app/services/jwt_service.rb
echo "# JWT Authentication" > AUTH.md

# Commit them
git add .
git commit -m "Add JWT service scaffold"
git commit --allow-empty -m "Add authentication docs"
```

### 3. List Worktrees

```bash
# From anywhere
/worktree-list
```

**Expected outcome:**
- Shows all worktrees with status
- Displays commit counts
- Indicates current location

### 4. Compare Changes

```bash
# Go back to main
cd ../demo-app  # or whatever your project is called

# Compare the feature branch
/worktree-compare feat/jwt-authentication-refresh
```

**Expected outcome:**
- Statistics of changes
- List of commits
- Conflict detection
- Detailed diff

### 5. Merge the Worktree

```bash
# Still in main directory
/worktree-merge feat/jwt-authentication-refresh
```

**Expected outcome:**
- Confirmation prompt
- Merge executed with --no-ff
- Push to remote (if configured)
- Complete cleanup (worktree + branches)

**Verify:**
```bash
git log --oneline -5
git worktree list
ls -la ../feat*  # Should not exist
```

## Testing Edge Cases

### 1. Test Error Handling

```bash
# Try to create worktree that already exists
/worktree-start rails feat/jwt-authentication-refresh
# Should show error: "Branch already exists"

# Try to merge from wrong directory
cd /tmp
/worktree-merge feat/some-branch
# Should show error or handle gracefully

# Try to create worktree with dirty working directory
echo "test" >> README.md
/worktree-start rails "new feature"
# Should stash changes first
```

### 2. Test Manual Mode

```bash
# Create worktree without AI assistance
/worktree-start rails feat/manual-feature
# Should be faster, no FEATURE.md generation
```

### 3. Test WordPress-Specific Features

```bash
/worktree-start wp "Add custom post type"
# Branch should use WordPress conventions: feature/*, bugfix/*
```

### 4. Test Parallel Development

```bash
# Create multiple worktrees
/worktree-start rails "Feature A"
/worktree-start rails "Feature B"
/worktree-start rails "Feature C"

# Work on all simultaneously
cd ../feat/feature-a && echo "A" > a.txt && git add . && git commit -m "A"
cd ../feat/feature-b && echo "B" > b.txt && git add . && git commit -m "B"
cd ../feat/feature-c && echo "C" > c.txt && git add . && git commit -m "C"

# List all
cd ../demo-app
/worktree-list

# Merge one at a time
/worktree-merge feat/feature-a
/worktree-merge feat/feature-b
/worktree-merge feat/feature-c
```

## Common Project Structures

### Rails Project Structure

```
demo-app/                       # Main repository (main branch)
├── .claude/
│   └── commands/
│       ├── worktree-start.md
│       ├── worktree-list.md
│       ├── worktree-compare.md
│       └── worktree-merge.md
├── app/
├── config/
├── db/
└── ...

../feat/jwt-authentication/     # Feature worktree
├── app/
├── config/
├── FEATURE.md                  # Generated guide
└── ...

../feat/user-profiles/          # Another feature worktree
└── ...
```

### WordPress Project Structure

```
demo-wp/                        # Main repository (main branch)
├── .claude/
│   └── commands/
├── public/
│   ├── themes/
│   └── plugins/
└── ...

../feature/contact-form/        # Feature worktree
├── public/
├── FEATURE.md
└── ...
```

## Verification Checklist

After testing, verify:

- [ ] Worktrees are created in sibling directories
- [ ] Branch naming follows conventions (Rails: feat/*, WordPress: feature/*)
- [ ] FEATURE.md is generated in smart mode
- [ ] Stashing works when needed
- [ ] /worktree-list shows all worktrees
- [ ] /worktree-compare detects conflicts
- [ ] /worktree-merge asks for confirmation
- [ ] Merge creates merge commit (--no-ff)
- [ ] Cleanup removes worktree directory
- [ ] Cleanup removes local branch
- [ ] Cleanup removes remote branch (if pushed)
- [ ] Error messages are clear and helpful
- [ ] Can work on multiple features in parallel
- [ ] No interference between worktrees

## Cleanup After Testing

```bash
# Remove all worktrees
/worktree-list

# For each worktree listed:
cd [worktree-directory]
cd ../[main-directory]
git worktree remove [worktree-path]

# Or manually:
rm -rf ../feat*  # Be careful with this!
git worktree prune
git branch -D feat/*  # Delete local branches

# Remove test project
cd ..
rm -rf demo-app  # or demo-wp
```

## Troubleshooting During Testing

### Commands not found

```bash
# Check Claude Code can see the commands
ls .claude/commands/

# Verify YAML frontmatter
head -5 .claude/commands/worktree-start.md
```

### Worktrees in wrong location

```bash
# Check git config
git config --local worktree.guessRemote

# Verify worktree creation
git worktree list
```

### Merge conflicts

```bash
# Test conflict resolution
# Create conflict intentionally:
echo "version 1" > test.txt
git add . && git commit -m "Version 1"
/worktree-start rails "conflict-test"
cd ../feat/conflict-test
echo "version 2" > test.txt
git add . && git commit -m "Version 2"
cd ../demo-app
echo "version 3" > test.txt
git add . && git commit -m "Version 3"
/worktree-compare feat/conflict-test
# Should detect conflict!
```

## Reporting Issues

If you find issues during testing:

1. Note the exact command that failed
2. Copy the full error message
3. Include your environment (OS, Git version, Claude Code version)
4. Create an issue: [GitHub Issues](https://github.com/yourusername/worktree-claude-code-commands/issues)

## Next Steps

Once testing is successful:

- Read [START_HERE.md](../START_HERE.md) for detailed workflows
- Check [CHEATSHEET.md](../CHEATSHEET.md) for quick reference
- Review [CONTRIBUTING.md](../CONTRIBUTING.md) to contribute improvements
