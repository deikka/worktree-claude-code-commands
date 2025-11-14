---
description: List, manage, and clean up git worktrees
allowed-tools: [bash_tool]
---

# List and Manage Worktrees

View all active worktrees and perform cleanup operations.

**Usage:**
- `/worktree-list` - List all worktrees
- `/worktree-list cleanup` - Remove merged worktrees
- `/worktree-list prune` - Clean up stale references

## Commands

### 1. List All Worktrees

**Default behavior (no arguments):**

```bash
if [ -z "$1" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🌿 ACTIVE WORKTREES"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  git worktree list
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 SUMMARY"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  WORKTREE_COUNT=$(git worktree list | wc -l)
  echo "Total worktrees: $WORKTREE_COUNT"
  echo ""
  
  # List branches
  echo "Branches in worktrees:"
  git worktree list | tail -n +2 | awk '{print "  -", $3}' | sort
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔧 AVAILABLE COMMANDS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "/worktree-list           - Show this list"
  echo "/worktree-list cleanup   - Remove merged worktrees"
  echo "/worktree-list prune     - Clean stale references"
  echo ""
  exit 0
fi
```

### 2. Cleanup Merged Worktrees

**Usage:** `/worktree-list cleanup`

**What it does:** Removes worktrees whose branches have been merged into main/master.

```bash
if [ "$1" = "cleanup" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🧹 CLEANUP MERGED WORKTREES"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  # Determine main branch
  if git show-ref --verify --quiet refs/heads/main; then
    MAIN_BRANCH="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    MAIN_BRANCH="master"
  else
    echo "❌ Error: Cannot find main/master branch"
    exit 1
  fi
  
  echo "📍 Main branch: $MAIN_BRANCH"
  echo ""
  
  # Find merged branches
  echo "🔍 Searching for merged branches..."
  MERGED_BRANCHES=$(git branch --merged "$MAIN_BRANCH" | grep -v '^\*' | grep -v "$MAIN_BRANCH")
  
  if [ -z "$MERGED_BRANCHES" ]; then
    echo "✅ No merged branches found. Nothing to clean up!"
    exit 0
  fi
  
  echo "Found merged branches:"
  echo "$MERGED_BRANCHES" | while read branch; do
    echo "  - $branch"
  done
  echo ""
  
  read -p "Remove these worktrees and branches? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup cancelled"
    exit 0
  fi
  
  echo ""
  REMOVED_COUNT=0

  # Use here-string to avoid subshell (pipe creates subshell, variable changes are lost)
  while IFS= read -r branch; do
    # Remove leading/trailing whitespace
    branch=$(echo "$branch" | xargs)

    # Skip empty lines
    [ -z "$branch" ] && continue

    # Check if worktree exists for this branch
    WORKTREE_PATH=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')

    if [ -n "$WORKTREE_PATH" ]; then
      echo "🗑️  Removing worktree: $WORKTREE_PATH ($branch)"
      git worktree remove "$WORKTREE_PATH" --force 2>/dev/null || {
        echo "⚠️  Could not remove worktree, trying manual cleanup..."
        rm -rf "$WORKTREE_PATH"
      }
      REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi

    # Delete the branch
    echo "🗑️  Deleting branch: $branch"
    git branch -d "$branch" 2>/dev/null || git branch -D "$branch"
  done <<< "$MERGED_BRANCHES"
  
  # Prune worktree references
  git worktree prune
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Cleanup complete!"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Removed $REMOVED_COUNT worktree(s)"
  echo ""
  echo "Remaining worktrees:"
  git worktree list
  echo ""
  exit 0
fi
```

### 3. Prune Stale References

**Usage:** `/worktree-list prune`

**What it does:** Removes stale worktree administrative files that no longer point to valid directories.

```bash
if [ "$1" = "prune" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔧 PRUNE STALE WORKTREE REFERENCES"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "🔍 Checking for stale references..."
  
  # List worktrees before
  BEFORE_COUNT=$(git worktree list | wc -l)
  
  # Prune
  git worktree prune -v
  
  # List worktrees after
  AFTER_COUNT=$(git worktree list | wc -l)
  PRUNED=$((BEFORE_COUNT - AFTER_COUNT))
  
  echo ""
  if [ $PRUNED -eq 0 ]; then
    echo "✅ No stale references found"
  else
    echo "✅ Pruned $PRUNED stale reference(s)"
  fi
  
  echo ""
  echo "Current worktrees:"
  git worktree list
  echo ""
  exit 0
fi
```

### 4. Invalid Argument

```bash
echo "❌ Error: Invalid argument '$1'"
echo ""
echo "Usage:"
echo "  /worktree-list           - List all worktrees"
echo "  /worktree-list cleanup   - Remove merged worktrees"
echo "  /worktree-list prune     - Clean stale references"
exit 1
```

## Understanding the Output

### git worktree list Output

```
/path/to/main/repo        abc123 [main]
/path/to/feature-branch   def456 [feat/user-auth]
/path/to/another-feature  ghi789 [fix/bug-123]
```

**Columns:**
1. **Path:** Physical location of the worktree
2. **Commit:** Current commit hash (short form)
3. **Branch:** Branch checked out in that worktree

**Main repository is always listed first** (marked with `[main]` or `[master]`)

### Merged vs Unmerged Branches

**Merged:** Changes are in main branch
- Safe to delete
- Cleanup command will remove these

**Unmerged:** Changes NOT in main branch
- Still being worked on
- Should NOT be deleted automatically
- Must be merged or manually deleted

## When to Use Each Command

### /worktree-list (No Arguments)

**Use when:**
- You forget which worktrees are active
- You want to see all branches being worked on
- You need to navigate to a specific worktree
- Checking before creating a new worktree

**Example:**
```bash
/worktree-list
# See you have 3 worktrees
# Navigate to one: cd /path/shown/in/list
```

### /worktree-list cleanup

**Use when:**
- After merging several feature branches
- Weekly/monthly maintenance
- Workspace is getting cluttered
- Want to remove only safe-to-delete worktrees

**Example:**
```bash
# After merging multiple features
/worktree-list cleanup
# Removes all merged worktrees automatically
```

### /worktree-list prune

**Use when:**
- Manually deleted a worktree directory
- Git still shows removed worktrees
- After filesystem cleanup/reorganization
- Getting "worktree already exists" errors

**Example:**
```bash
# You deleted ../old-feature manually
# But git worktree list still shows it
/worktree-list prune
# Cleans up the reference
```

## Common Scenarios

### Scenario 1: Finding Your Worktrees

```bash
# You have multiple terminals open and forgot which worktrees exist
/worktree-list

# Output shows:
# /Users/you/project        [main]
# /Users/you/feat-auth      [feat/authentication]
# /Users/you/fix-bug        [fix/login-bug]

# Navigate to one:
cd /Users/you/feat-auth
```

### Scenario 2: Post-Merge Cleanup

```bash
# You've merged 3 features today using /worktree-merge
# Directories are cleaned up, but branches might still exist

/worktree-list cleanup

# Reviews merged branches
# Removes any lingering references
# Deletes merged local branches
```

### Scenario 3: Manual Cleanup Needed

```bash
# You accidentally deleted a worktree directory
rm -rf ../old-feature

# Git still thinks it exists
/worktree-list
# Shows: /path/to/old-feature [old-feature] (but directory doesn't exist)

# Clean up the reference
/worktree-list prune

# Now git worktree list shows only valid worktrees
```

### Scenario 4: Weekly Maintenance

```bash
# Every Friday, clean up your workspace

# 1. See what's active
/worktree-list

# 2. Remove merged branches
/worktree-list cleanup

# 3. Clean stale references
/worktree-list prune

# Fresh start for next week!
```

## Advanced Usage

### Manual Worktree Removal

**If you need to remove a specific worktree manually:**

```bash
# From anywhere
git worktree remove /path/to/worktree

# With force (if there are uncommitted changes)
git worktree remove /path/to/worktree --force

# Then delete the branch
git branch -D branch-name
```

### List Worktrees Programmatically

```bash
# Get worktree paths only
git worktree list | awk '{print $1}'

# Get branch names only
git worktree list | grep -oP '\[\K[^\]]+'

# Count worktrees
git worktree list | wc -l
```

### Check If Branch Has Worktree

```bash
# Check if a branch has an active worktree
git worktree list | grep "branch-name"

# In a script
if git worktree list | grep -q "branch-name"; then
  echo "Branch has a worktree"
else
  echo "No worktree for this branch"
fi
```

## Troubleshooting

### "Cannot remove worktree" errors

**Cause:** Directory is in use (IDE, terminal, etc.)

**Solution:**
1. Close all programs using that directory
2. Try again, or use `--force`
3. If still failing, manually delete:
   ```bash
   rm -rf /path/to/worktree
   git worktree prune
   ```

### "Branch is not fully merged" warning

**Cause:** Branch has commits not in main

**Solution:**
- If you're SURE you want to delete:
  ```bash
  git branch -D branch-name
  ```
- If you want to merge first:
  ```bash
  git checkout main
  git merge branch-name
  git push
  # Then cleanup
  ```

### Cleanup doesn't find merged branches

**Cause:** Remote tracking branches aren't updated

**Solution:**
```bash
# Update from remote
git fetch --all --prune

# Try cleanup again
/worktree-list cleanup
```

### Stale references remain after prune

**Cause:** Corrupted git metadata

**Solution:**
```bash
# Nuclear option - clean everything
git worktree prune
rm -rf .git/worktrees/*
git worktree list  # Should only show main repo now

# Recreate worktrees as needed
```

## Best Practices

### 1. Regular Cleanup

```bash
# Set a reminder to run weekly
/worktree-list cleanup
/worktree-list prune
```

**Why:** Prevents workspace clutter and reduces confusion

### 2. Check Before Creating

```bash
# Before creating a new worktree
/worktree-list

# See if branch already exists
# Avoid duplicate worktrees
```

### 3. Document Active Work

```bash
# Keep a file documenting your worktrees
/worktree-list > ACTIVE_WORK.txt

# Review periodically
cat ACTIVE_WORK.txt
```

### 4. Use Cleanup Over Manual Deletion

**❌ Bad:**
```bash
rm -rf ../old-feature
git branch -D old-feature
```

**✅ Good:**
```bash
# Merge first
cd ../old-feature
/worktree-merge main

# Or if already merged, cleanup finds it
/worktree-list cleanup
```

### 5. Prune After Filesystem Changes

```bash
# If you moved/deleted directories manually
/worktree-list prune

# Keeps git's view accurate
```

## Integration with Other Commands

### After /worktree-merge

```bash
# Merge cleans up automatically, but verify:
/worktree-list

# Should not show merged worktree anymore
```

### Before /worktree-start

```bash
# Check if branch already has worktree
/worktree-list

# If it exists, navigate there instead
cd /path/from/list
```

### Weekly Workflow

```bash
# Monday: Plan week, see active work
/worktree-list

# Friday: Clean up merged work
/worktree-list cleanup
/worktree-list prune
```

## What Happens Next

### After /worktree-list (no args)

- You see all active worktrees
- Can navigate to any of them
- Know what branches are being worked on

### After /worktree-list cleanup

- Merged worktrees are removed
- Merged branches are deleted
- Workspace is tidier
- Only active work remains

### After /worktree-list prune

- Stale administrative files removed
- Git's worktree list is accurate
- No phantom worktrees shown

## Example Session

```bash
# See current state
$ /worktree-list
🌿 ACTIVE WORKTREES
/Users/dev/myproject          [main]
/Users/dev/feat-auth          [feat/authentication]
/Users/dev/feat-search        [feat/search-engine]
/Users/dev/fix-bug            [fix/login-bug]

# Merge a feature
$ cd /Users/dev/feat-auth
$ /worktree-merge main
✅ Merged and cleaned up

# Back to main, check again
$ cd /Users/dev/myproject
$ /worktree-list
🌿 ACTIVE WORKTREES
/Users/dev/myproject          [main]
/Users/dev/feat-search        [feat/search-engine]
/Users/dev/fix-bug            [fix/login-bug]

# Merge another
$ cd /Users/dev/fix-bug
$ /worktree-merge main
✅ Merged and cleaned up

# Final cleanup
$ /worktree-list cleanup
✅ Cleanup complete! Removed 0 worktrees (already clean)

# Only active work remains
$ /worktree-list
🌿 ACTIVE WORKTREES
/Users/dev/myproject          [main]
/Users/dev/feat-search        [feat/search-engine]
```

## Summary

**Three simple commands for worktree management:**

1. **List:** See what's active
   ```bash
   /worktree-list
   ```

2. **Cleanup:** Remove merged worktrees
   ```bash
   /worktree-list cleanup
   ```

3. **Prune:** Fix stale references
   ```bash
   /worktree-list prune
   ```

**Use regularly to maintain a clean, organized workspace.**
