# Verification Checklist for Slash Commands

## ⚠️ IMPORTANT: Test Before Publishing

These slash commands need manual verification in Claude Code before GitHub release.

## Testing Procedure

### 1. Setup Test Environment

```bash
# Create a test git repository
cd /tmp
mkdir worktree-test-repo
cd worktree-test-repo
git init
echo "# Test" > README.md
git add .
git commit -m "Initial commit"
```

### 2. Install Commands in Test Repo

```bash
# Copy commands to test repo
mkdir -p .claude/commands
cp /Users/alex/Desktop/dev_apps/worktree-claude-code-commands/worktree-*.md .claude/commands/
```

### 3. Test Each Command

#### Test /worktree-start

**Expected behavior:**
- Claude Code should parse the YAML front matter
- Execute bash commands sequentially
- Generate branch name (in smart mode)
- Create worktree directory
- Create FEATURE.md with AI-generated content

**Test cases:**
```bash
# Smart mode - Rails
/worktree-start rails "Add user authentication system"

# Manual mode - Rails
/worktree-start rails feat/user-auth

# Smart mode - WordPress
/worktree-start wp "Add contact form with validation"

# Manual mode - WordPress
/worktree-start wp feature/contact-form
```

**Verification:**
- [ ] Branch created with correct naming convention
- [ ] Worktree directory exists at `../[branch-name]`
- [ ] FEATURE.md generated (smart mode only)
- [ ] Current changes stashed if any
- [ ] Error handling works (duplicate branch, invalid input)

#### Test /worktree-list

**Expected behavior:**
- List all active worktrees
- Show branch and path for each
- Highlight current worktree

**Test cases:**
```bash
/worktree-list
```

**Verification:**
- [ ] Shows all worktrees correctly
- [ ] Formatting is clear and readable
- [ ] Current worktree is highlighted

#### Test /worktree-compare

**Expected behavior:**
- Show statistics of changes
- List commits
- Detect potential conflicts
- Show detailed diff

**Test cases:**
```bash
# Switch to a worktree and make some changes
cd ../feat/user-auth
echo "test" >> test.txt
git add .
git commit -m "Test commit"

# Return to main and compare
cd ../main
/worktree-compare feat/user-auth
```

**Verification:**
- [ ] Shows file count and line changes
- [ ] Lists commits correctly
- [ ] Detects conflicts if any
- [ ] Displays diff (preferably with Delta)

#### Test /worktree-merge

**Expected behavior:**
- Run pre-flight checks
- Merge with --no-ff
- Push to remote (if configured)
- Clean up worktree and branches
- Ask for confirmation before destructive operations

**Test cases:**
```bash
/worktree-merge feat/user-auth
```

**Verification:**
- [ ] Asks for confirmation before merge
- [ ] Creates merge commit
- [ ] Attempts push to remote
- [ ] Removes worktree directory
- [ ] Deletes local branch
- [ ] Deletes remote branch (if pushed)
- [ ] Returns to main/master branch

## Common Issues to Watch For

### Issue 1: Bash Execution
**Problem:** Claude Code might not execute bash directly from markdown
**Solution:** Commands may need to be in executable script format

### Issue 2: Interactive Prompts
**Problem:** Commands with `read -p` might not work in Claude Code
**Solution:** May need to use Claude's native prompt mechanism

### Issue 3: Variable Substitution
**Problem:** Bash variables in heredocs might not expand correctly
**Solution:** May need different quoting or escaping

### Issue 4: Multi-line Output
**Problem:** Long outputs might be truncated
**Solution:** May need pagination or summary views

### Issue 5: Current Directory
**Problem:** Commands assume execution from repo root
**Solution:** May need to add `cd` commands or path validation

## Results

After testing, document:

1. **What works:**
   - [ ] Command 1: /worktree-start
   - [ ] Command 2: /worktree-list
   - [ ] Command 3: /worktree-compare
   - [ ] Command 4: /worktree-merge

2. **What doesn't work:**
   - [ ] List issues here

3. **Required fixes:**
   - [ ] Document changes needed

## Next Steps

Based on results:
- ✅ **If all work:** Proceed with GitHub preparation
- ⚠️ **If partial:** Fix issues and re-test
- ❌ **If none work:** Refactor command format

---

**Date tested:** _______________
**Claude Code version:** _______________
**Tester:** _______________
