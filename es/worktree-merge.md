---
description: Merge worktree changes and clean up safely
allowed-tools: [bash_tool]
---

# Merge Worktree and Cleanup

Merge changes from the current worktree into a target branch and automatically clean up the worktree.

**Usage:** `/worktree-merge [target-branch]`

**Arguments:**
- `$1`: Target branch to merge into (default: auto-detect main/master)

## What This Does

**CRITICAL OPERATIONS:**
1. Validates current state (uncommitted changes, etc.)
2. Switches to target branch in main repository
3. Merges your worktree branch
4. Pushes changes to remote
5. Deletes the worktree branch
6. Removes the worktree directory
7. Returns you to the main repository

**⚠️ WARNING:** This is destructive. Make sure you've reviewed changes with `/worktree-compare` first.

## Process

### 1. Pre-flight Checks

```bash
# Verify we're in a worktree
CURRENT_BRANCH=$(git branch --show-current)
WORKTREE_DIR=$(git rev-parse --git-common-dir)

if [[ ! "$WORKTREE_DIR" == *".git/worktrees"* ]]; then
  echo "❌ Error: You're not in a worktree"
  echo "💡 Tip: Navigate to a worktree directory first"
  exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "❌ Error: You have uncommitted changes"
  echo ""
  git status --short
  echo ""
  echo "💡 Commit or stash your changes first:"
  echo "   git add ."
  echo "   git commit -m 'Your message'"
  exit 1
fi

# Check if branch is pushed
if ! git rev-parse --verify "origin/$CURRENT_BRANCH" > /dev/null 2>&1; then
  echo "⚠️  Warning: Branch not pushed to remote"
  read -p "Push now? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push -u origin "$CURRENT_BRANCH"
  else
    echo "❌ Merge cancelled. Push your branch first."
    exit 1
  fi
fi

echo "✅ Pre-flight checks passed"
echo "📍 Current worktree: $CURRENT_BRANCH"
echo ""
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
    echo "💡 Tip: Specify target branch: /worktree-merge develop"
    exit 1
  fi
fi

# Verify target branch exists
if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
  echo "❌ Error: Branch '$TARGET_BRANCH' doesn't exist"
  exit 1
fi

echo "🎯 Merging into: $TARGET_BRANCH"
echo ""
```

### 3. Final Confirmation

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  FINAL CONFIRMATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "About to merge:"
echo "  FROM: $CURRENT_BRANCH (this worktree)"
echo "  INTO: $TARGET_BRANCH"
echo ""
echo "This will:"
echo "  1. Merge your changes"
echo "  2. Push to remote"
echo "  3. Delete branch $CURRENT_BRANCH"
echo "  4. Remove this worktree directory"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ Merge cancelled"
  exit 0
fi
echo ""
```

### 4. Navigate to Main Repository

```bash
REPO_ROOT=$(git rev-parse --show-toplevel | sed 's/\/\.git\/worktrees\/.*//')
WORKTREE_PATH=$(pwd)

echo "🚶 Navigating to main repository..."
cd "$REPO_ROOT"

if [ "$(git branch --show-current)" != "$TARGET_BRANCH" ]; then
  echo "🔄 Switching to $TARGET_BRANCH..."
  git checkout "$TARGET_BRANCH"
fi

# Update target branch from remote
echo "⬇️  Updating $TARGET_BRANCH from remote..."
git pull origin "$TARGET_BRANCH"
echo ""
```

### 5. Perform Merge

```bash
echo "🔀 Merging $CURRENT_BRANCH into $TARGET_BRANCH..."
echo ""

# Attempt merge
if git merge --no-ff "$CURRENT_BRANCH" -m "Merge branch '$CURRENT_BRANCH'"; then
  echo ""
  echo "✅ Merge successful!"
else
  echo ""
  echo "❌ Merge failed - conflicts detected"
  echo ""
  echo "To resolve:"
  echo "  1. Fix conflicts in the files listed above"
  echo "  2. git add <resolved-files>"
  echo "  3. git commit"
  echo "  4. Re-run /worktree-merge $TARGET_BRANCH"
  echo ""
  echo "To abort:"
  echo "  git merge --abort"
  exit 1
fi
```

### 6. Push to Remote

```bash
echo "⬆️  Pushing to remote..."
git push origin "$TARGET_BRANCH"

if [ $? -ne 0 ]; then
  echo "❌ Push failed"
  echo "💡 Tip: Resolve manually and re-run this command"
  exit 1
fi

echo "✅ Push successful!"
echo ""
```

### 7. Clean Up Worktree

```bash
echo "🧹 Cleaning up worktree..."

# Remove worktree
git worktree remove "$WORKTREE_PATH" --force 2>/dev/null || {
  echo "⚠️  Could not auto-remove worktree directory"
  echo "Manual cleanup needed: rm -rf $WORKTREE_PATH"
}

# Delete branch
git branch -d "$CURRENT_BRANCH"

if [ $? -ne 0 ]; then
  echo "⚠️  Local branch deletion failed (may need -D flag)"
  read -p "Force delete? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -D "$CURRENT_BRANCH"
  fi
fi

# Delete remote branch
read -p "Delete remote branch origin/$CURRENT_BRANCH? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git push origin --delete "$CURRENT_BRANCH"
  echo "✅ Remote branch deleted"
else
  echo "ℹ️  Remote branch kept: origin/$CURRENT_BRANCH"
fi

echo ""
```

### 8. Summary

```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 MERGE COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Changes from $CURRENT_BRANCH merged into $TARGET_BRANCH"
echo "✅ Pushed to remote"
echo "✅ Worktree cleaned up"
echo "📍 You are now in: $TARGET_BRANCH"
echo ""
echo "🔄 Active worktrees:"
git worktree list
echo ""
```

## Error Handling

### Merge Conflicts

**If merge conflicts occur:**

```bash
# You'll see something like:
# CONFLICT (content): Merge conflict in app/models/user.rb
# Automatic merge failed; fix conflicts and then commit the result.

# Steps to resolve:
1. Open conflicted files (marked with <<<<<<<, =======, >>>>>>>)
2. Resolve conflicts manually
3. git add <resolved-files>
4. git commit
5. git push origin $TARGET_BRANCH
6. Re-run: /worktree-merge $TARGET_BRANCH (to finish cleanup)
```

**Prevention:** Always run `/worktree-compare` first to check for potential conflicts.

### Push Rejected

**Cause:** Someone else pushed to target branch while you were working

**Solution:**
```bash
# Pull latest changes
git pull origin $TARGET_BRANCH --rebase

# Resolve any conflicts that arise
git add .
git rebase --continue

# Try push again
git push origin $TARGET_BRANCH

# Resume cleanup manually or re-run command
```

### Worktree Can't Be Removed

**Cause:** Directory is in use (IDE, terminal open)

**Solution:**
```bash
# Close all instances using that directory
# Then manually remove:
git worktree remove /path/to/worktree --force

# Or:
rm -rf /path/to/worktree
git worktree prune
```

## Best Practices

### 1. Always Compare First

```bash
# NEVER merge without reviewing
/worktree-compare main   # Review changes
/worktree-merge main     # Then merge
```

### 2. Run Tests Before Merging

```bash
# Rails
bin/rails test

# WordPress (if tests configured)
vendor/bin/phpunit

# Then merge
/worktree-merge main
```

### 3. Keep Branches Short-Lived

- Merge within 1-3 days
- Smaller merges = fewer conflicts
- Easier to review

### 4. Clean Commit History

```bash
# Before merging, squash WIP commits if needed
git rebase -i HEAD~3  # Interactive rebase last 3 commits

# Or use --squash on merge
git merge --squash $CURRENT_BRANCH
```

### 5. Use Pull Requests (If Team Workflow)

Instead of direct merge, consider:
```bash
# Push your branch
git push origin $CURRENT_BRANCH

# Create PR on GitHub/GitLab
# Get review
# Merge via PR interface
# Then manually cleanup worktree:
/worktree-list cleanup
```

## Stack-Specific Considerations

### Rails Projects

**Before merging:**
- [ ] `bin/rails test` passes
- [ ] `bundle exec rubocop` is clean
- [ ] Migrations are reversible
- [ ] Schema.rb is updated
- [ ] No `binding.pry` left in code

**After merging:**
```bash
# In main branch, run migrations
bin/rails db:migrate

# Restart server
bin/rails s
```

### WordPress Projects

**Before merging:**
- [ ] `npm run build` completes
- [ ] No `var_dump()` in code
- [ ] Plugin/theme version bumped
- [ ] Composer dependencies updated

**After merging:**
```bash
# Rebuild assets
npm run build

# Update composer if needed
composer install

# Clear WordPress cache if applicable
wp cache flush
```

## Workflow Example

```bash
# Complete workflow from start to merge

# 1. Create worktree for feature
/worktree-start rails "Add user authentication"

# 2. Work on feature
cd ../feat/user-authentication
# ... coding, testing, committing ...

# 3. Before merging, compare
/worktree-compare main
# Review all changes carefully

# 4. Run tests
bin/rails test
bundle exec rubocop

# 5. Merge and cleanup
/worktree-merge main

# 6. Verify you're back in main
pwd  # Should be main repository
git branch --show-current  # Should be 'main'
```

## Advanced: Merge Strategies

### Default: --no-ff (No Fast-Forward)

**This command uses --no-ff by default**

```bash
git merge --no-ff $CURRENT_BRANCH
```

**Why:** Creates a merge commit even if fast-forward is possible
- **Pro:** Clear history showing when feature was integrated
- **Pro:** Easy to revert entire feature with one command
- **Con:** More commits in history

### Alternative: Squash Merge (Manual)

**If you want all commits squashed into one:**

```bash
# Instead of using this command, do:
cd $REPO_ROOT
git checkout main
git merge --squash $CURRENT_BRANCH
git commit -m "feat: Add user authentication

- JWT token generation
- Refresh token mechanism
- Session management
- Tests for auth flow"
git push origin main

# Then cleanup worktree manually
git worktree remove ../feat/user-authentication
git branch -D feat/user-authentication
```

**When to use:**
- Many small WIP commits
- Want clean, linear history
- Feature is atomic and can be represented as one commit

### Alternative: Rebase (Manual)

**If you want to rewrite history:**

```bash
# From your worktree
git rebase -i main  # Interactive rebase

# Clean up commits, then
cd $REPO_ROOT
git checkout main
git merge $CURRENT_BRANCH  # Will be fast-forward
git push origin main

# Cleanup worktree
```

**When to use:**
- Want linear history
- No merge commits
- Comfortable with rewriting history

**⚠️ Warning:** Don't rebase if others are working on the same branch.

## Rollback

**If you need to undo a merge:**

### Immediately After Merge (Not Pushed)

```bash
git reset --hard HEAD~1
```

### After Push (Use Revert)

```bash
# Find the merge commit
git log --oneline

# Revert the merge
git revert -m 1 <merge-commit-hash>
git push origin main
```

**⚠️ Warning:** Reverting is permanent. Only do this if you're certain.

## What Happens Next

After running this command successfully:

1. ✅ Your feature branch is merged into target
2. ✅ Changes are pushed to remote
3. ✅ Worktree directory is removed
4. ✅ Feature branch is deleted (local and optionally remote)
5. ✅ You're back in the main repository on the target branch
6. ✅ Your workspace is clean and ready for the next feature

**You can now:**
- Start a new feature: `/worktree-start rails "Next feature"`
- Continue working in main repository
- Pull latest changes: `git pull`

## Troubleshooting

### "Not in a worktree" error

**Cause:** Running from main repo

**Solution:** Navigate to worktree first
```bash
cd ../your-feature-branch
/worktree-merge main
```

### "Uncommitted changes" error

**Cause:** You have unsaved work

**Solution:** Commit or stash
```bash
git add .
git commit -m "Final changes"
# Then retry merge
```

### Merge conflict resolution

See "Error Handling > Merge Conflicts" section above

### Can't delete branch

**Cause:** Branch has unmerged commits

**Solution:** Force delete
```bash
git branch -D $CURRENT_BRANCH
```

### Remote branch still exists

**Solution:** Delete manually
```bash
git push origin --delete branch-name
```
