---
description: Compare worktree changes with target branch before merging
allowed-tools: [bash_tool]
---

# Compare Worktree Changes

Visualize all changes in the current worktree compared to a target branch (usually main/master).

**Usage:** `/worktree-compare [target-branch]`

**Arguments:**
- `$1`: Target branch to compare against (default: auto-detect main/master)

## What This Shows You

**CRITICAL:** This command provides multiple views to understand your changes:

1. **High-level stats** - Files changed, insertions, deletions
2. **Commit log** - All commits made in this worktree
3. **File-by-file diff** - Detailed changes for review
4. **Potential conflicts** - Files that changed in both branches

## Process

### 1. Detect Current Context

```bash
# Verify we're in a worktree
CURRENT_BRANCH=$(git branch --show-current)
WORKTREE_DIR=$(git rev-parse --git-common-dir)

if [[ ! "$WORKTREE_DIR" == *".git/worktrees"* ]]; then
  echo "❌ Error: You're not in a worktree"
  echo "💡 Tip: Navigate to a worktree directory first"
  exit 1
fi

echo "📍 Current worktree: $CURRENT_BRANCH"
```

### 2. Determine Target Branch

```bash
TARGET_BRANCH="${1:-}"

# Auto-detect if not provided
if [ -z "$TARGET_BRANCH" ]; then
  if git show-ref --verify --quiet refs/heads/main; then
    TARGET_BRANCH="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    TARGET_BRANCH="master"
  else
    echo "❌ Error: Cannot auto-detect main branch"
    echo "💡 Tip: Specify target branch explicitly: /worktree-compare develop"
    exit 1
  fi
fi

# Verify target branch exists
if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
  echo "❌ Error: Branch '$TARGET_BRANCH' doesn't exist"
  exit 1
fi

echo "🎯 Comparing against: $TARGET_BRANCH"
echo ""
```

### 3. Update Target Branch

```bash
echo "🔄 Updating $TARGET_BRANCH from remote..."
git fetch origin "$TARGET_BRANCH:$TARGET_BRANCH" 2>/dev/null || true
echo ""
```

### 4. Display High-Level Statistics

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 CHANGE SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show shortstat
git diff --shortstat "$TARGET_BRANCH..$CURRENT_BRANCH"
echo ""

# Show files changed with status
echo "📁 Files Changed:"
git diff --name-status "$TARGET_BRANCH..$CURRENT_BRANCH" | while read status file; do
  case "$status" in
    A) echo "  ✅ Added:    $file" ;;
    M) echo "  📝 Modified: $file" ;;
    D) echo "  ❌ Deleted:  $file" ;;
    R*) echo "  🔄 Renamed:  $file" ;;
  esac
done
echo ""
```

### 5. Display Commit Log

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 COMMIT HISTORY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

git log "$TARGET_BRANCH..$CURRENT_BRANCH" --oneline --decorate --graph --color=always
echo ""
```

### 6. Check for Potential Conflicts

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  CONFLICT DETECTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Files changed in both branches
COMMON_FILES=$(comm -12 \
  <(git diff --name-only "$TARGET_BRANCH..$CURRENT_BRANCH" | sort) \
  <(git diff --name-only "$CURRENT_BRANCH..$TARGET_BRANCH" | sort))

if [ -z "$COMMON_FILES" ]; then
  echo "✅ No potential conflicts detected"
  echo "   (No files were modified in both branches)"
else
  echo "⚠️  Potential conflicts in these files:"
  echo "$COMMON_FILES" | while read file; do
    echo "  - $file"
  done
  echo ""
  echo "💡 Review these carefully before merging"
fi
echo ""
```

### 7. Show Detailed Diff

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 DETAILED CHANGES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Showing full diff (press 'q' to exit, '/' to search)..."
echo ""

# Use delta if available, otherwise plain git diff
if command -v delta &> /dev/null; then
  git diff "$TARGET_BRANCH..$CURRENT_BRANCH" | delta
else
  git diff "$TARGET_BRANCH..$CURRENT_BRANCH" --color=always | less -R
fi
```

### 8. Interactive Options

```bash
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤔 WHAT'S NEXT?"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Review the changes above. Options:"
echo ""
echo "1. ✅ Merge if satisfied:"
echo "   /worktree-merge $TARGET_BRANCH"
echo ""
echo "2. 🔄 Make more changes:"
echo "   (Continue working in this worktree)"
echo ""
echo "3. 📊 Re-compare later:"
echo "   /worktree-compare $TARGET_BRANCH"
echo ""
echo "4. 🔍 View specific file changes:"
echo "   git diff $TARGET_BRANCH -- path/to/file"
echo ""
echo "5. 🧪 Test merge without committing:"
echo "   git merge --no-commit --no-ff $TARGET_BRANCH"
echo "   (then git merge --abort to undo)"
echo ""
```

## Advanced Comparisons

### Compare Specific Files

```bash
# User can run manually if needed
git diff "$TARGET_BRANCH..$CURRENT_BRANCH" -- path/to/specific/file
```

### Compare With Statistics by File

```bash
git diff "$TARGET_BRANCH..$CURRENT_BRANCH" --stat
```

### Show Only File Names

```bash
git diff "$TARGET_BRANCH..$CURRENT_BRANCH" --name-only
```

### Compare Specific Commit Range

```bash
git diff <commit-hash1>..<commit-hash2>
```

## Interpreting the Output

### 1. Change Summary

```
3 files changed, 45 insertions(+), 12 deletions(-)
```

- **Files changed:** Number of files modified
- **Insertions:** Lines added
- **Deletions:** Lines removed

**Rule of thumb:**
- <100 lines changed: Small, easy to review
- 100-500 lines: Medium, take your time
- >500 lines: Large, consider breaking into smaller merges

### 2. File Status Symbols

- `A` (Added): New file created
- `M` (Modified): Existing file changed
- `D` (Deleted): File removed
- `R` (Renamed): File moved/renamed

### 3. Commit Log

Shows your commits that will be merged. Each commit should:
- Have a clear, descriptive message
- Be atomic (one logical change per commit)
- Follow your project's commit conventions

**Red flag:** If you see "WIP", "test", or "fix typo" commits, consider squashing/rebasing first.

### 4. Conflict Detection

**No conflicts:** Safe to merge
**Potential conflicts:** Files modified in both branches
  - Review these files carefully
  - Consider testing merge first: `git merge --no-commit --no-ff <target>`
  - Resolve conflicts manually if they occur

### 5. Detailed Diff

**Green (+):** Lines added
**Red (-):** Lines removed

**What to look for:**
- ❌ Accidental debugging code (console.log, binding.pry, etc.)
- ❌ Commented-out code that should be removed
- ❌ TODOs or FIXMEs that weren't addressed
- ❌ Sensitive data (API keys, passwords)
- ✅ Tests covering new functionality
- ✅ Documentation updates
- ✅ Clean, readable code

## Stack-Specific Checks

### Rails Projects

**Before merging, verify:**
- [ ] All migrations are included
- [ ] Schema.rb is up-to-date
- [ ] Tests pass: `bin/rails test`
- [ ] Rubocop is happy: `bundle exec rubocop`
- [ ] No `binding.pry` or `debugger` calls left
- [ ] Routes file is clean
- [ ] Gemfile.lock is committed if Gemfile changed

**Check for:**
```bash
# Find debugging statements
git diff $TARGET_BRANCH | grep -E "(binding.pry|debugger|byebug)"

# Find console.log equivalents
git diff $TARGET_BRANCH | grep -E "(puts|pp |p )"

# Check for pending migrations
git diff $TARGET_BRANCH --name-only | grep "db/migrate"
```

### WordPress Projects

**Before merging, verify:**
- [ ] No `var_dump()` or `print_r()` calls left
- [ ] Composer.lock updated if composer.json changed
- [ ] Assets compiled: `npm run build`
- [ ] Plugin/theme version bumped if needed
- [ ] No test credentials in code

**Check for:**
```bash
# Find debugging statements
git diff $TARGET_BRANCH | grep -E "(var_dump|print_r|dd\(|dump\()"

# Check for API keys/secrets
git diff $TARGET_BRANCH | grep -iE "(api_key|secret|password)"

# Check asset compilation
git diff $TARGET_BRANCH --name-only | grep -E "(resources/|public/)"
```

## When to NOT Merge

**Stop and fix if you see:**

1. **Tests failing:** Fix before merging
2. **Linting errors:** Clean up code first
3. **Merge conflicts:** Resolve them
4. **Debugging code:** Remove it
5. **Uncommitted changes:** Commit or stash
6. **Large, unrelated changes:** Split into separate PRs/merges
7. **Missing tests:** Add them
8. **Breaking changes:** Document and coordinate with team

## Pro Tips

### 1. Use Delta for Better Diffs

```bash
# Install delta (highly recommended)
brew install git-delta  # macOS
# or
cargo install git-delta

# Automatic in this command if delta is available
```

### 2. Compare with Different Base

```bash
# Compare with develop instead of main
/worktree-compare develop

# Compare with a specific commit
git diff <commit-hash>..HEAD
```

### 3. Visual Diff Tools

```bash
# Use your preferred visual diff tool
git difftool $TARGET_BRANCH..$CURRENT_BRANCH
```

### 4. Generate Patch File

```bash
# Create a patch file for review
git diff $TARGET_BRANCH..$CURRENT_BRANCH > changes.patch
```

### 5. Check Specific Commit

```bash
# See changes in a specific commit
git show <commit-hash>
```

## Workflow Example

```bash
# 1. You've been working on a feature
cd ../feat/user-authentication

# 2. Before merging, compare your changes
/worktree-compare main

# 3. Review the output carefully
#    - Check file changes make sense
#    - Review commits are clean
#    - Verify no conflicts
#    - Inspect detailed diff

# 4. Fix any issues you found
git commit -am "Remove debugging code"

# 5. Compare again
/worktree-compare main

# 6. If everything looks good
/worktree-merge main
```

## Troubleshooting

### "Not in a worktree" error

**Cause:** You're in the main repository, not a worktree

**Solution:**
```bash
cd ../your-feature-branch-name
/worktree-compare main
```

### "Branch doesn't exist" error

**Cause:** Target branch name is wrong

**Solution:**
```bash
# List available branches
git branch -a

# Use correct branch name
/worktree-compare correct-branch-name
```

### Diff tool shows nothing

**Cause:** No changes between branches

**Solution:** This means your worktree is identical to the target - either you haven't made changes or you already merged.

### Too many changes to review

**Cause:** Large feature with many files changed

**Solution:**
```bash
# Review one file at a time
git diff main -- app/models/user.rb
git diff main -- app/controllers/users_controller.rb

# Or use file-by-file navigation
git diff main --name-only | xargs -I {} sh -c 'echo "\n=== {} ===" && git diff main -- {}'
```

## What Happens Next

After running this command:

1. ✅ You've seen all changes vs target branch
2. ✅ You know if there are potential conflicts
3. ✅ You've reviewed the detailed diff
4. ✅ You're ready to decide: merge or continue working

**Next steps:**
- **If satisfied:** Run `/worktree-merge <target-branch>`
- **If issues found:** Fix them, commit, and compare again
- **If uncertain:** Get a code review first
