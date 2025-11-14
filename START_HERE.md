# 🚀 START HERE: Git Worktrees with Claude Code

**Version 1.1.0** - Now with 7 stack support, verbose mode, and local configuration!

This guide will help you get started in **2 minutes** with the worktree system.

## ⚡ Quick Start (60 seconds)

```bash
# 1. Install (only once)
cd /path/to/your/project
./install.sh

# 2. Create your first worktree (SMART MODE)
/worktree-start rails "Add user authentication with JWT"

# 3. Work on the feature
cd ../feat/user-authentication-jwt
# ... code, commits ...

# 4. Compare before merge
/worktree-compare main

# 5. Merge when ready
/worktree-merge main
```

Done! You can now work on multiple features simultaneously.

---

## 🎯 What Problem Does This Solve?

**Before (without worktrees):**
```bash
# You're working on feature A
git checkout -b feature-a
# ... making changes ...

# OH NO! Urgent bug in production
# You have to:
git stash          # Save changes
git checkout main  # Switch branch
git checkout -b hotfix
# ... fix bug ...
git checkout feature-a
git stash pop      # Recover changes
# Oops, conflicts with stash...
```

**Now (with worktrees):**
```bash
# Terminal 1: Working on feature A
/worktree-start rails "Feature A"
cd ../feat/feature-a
# ... making changes peacefully ...

# Terminal 2: Urgent bug
/worktree-start rails "Hotfix urgent bug"
cd ../hotfix/urgent-bug
# ... fix the bug ...
/worktree-merge main

# Terminal 1: Continue working without interruptions
# No stashes, no conflicts, no stress
```

---

## 📚 The 4 Essential Commands

### 1. `/worktree-start` - Create new worktree

**Smart Mode (RECOMMENDED):**
```bash
# Rails
/worktree-start rails "Add JWT authentication with refresh tokens"

# Node.js (with aliases)
/worktree-start node "Implement websocket server"
/worktree-start js "Add GraphQL API"  # alias

# Python
/worktree-start python "Add ML model for recommendations"
/worktree-start py "Fix data pipeline"  # alias

# WordPress
/worktree-start wordpress "Create custom blocks"
/worktree-start wp "Fix admin panel"  # alias

# Other stacks
/worktree-start go "Add microservice"
/worktree-start rust "Optimize parser"
/worktree-start generic "Update documentation"
```
- Claude analyzes your description
- Generates appropriate branch name
- Creates `FEATURE.md` with context and checklist
- Tells you where to start

**Manual Mode:**
```bash
/worktree-start rails user-authentication
```
- Uses the name you specify directly
- Faster but without AI assistant

**Verbose Mode (for debugging):**
```bash
/worktree-start -v rails "Add feature"
```
- Shows all bash commands being executed
- Useful for troubleshooting

### 2. `/worktree-compare` - View changes before merge

```bash
/worktree-compare main
```

**Shows you:**
- ✅ Summary of files changed
- ✅ List of commits
- ✅ Detection of potential conflicts
- ✅ Full diff for review

**Golden rule:** ALWAYS compare before merging.

### 3. `/worktree-merge` - Merge and clean up

```bash
/worktree-merge main
```

**Does everything automatically:**
1. Validates no uncommitted changes
2. Merges to main branch
3. Push to remote
4. Deletes the worktree
5. Deletes the branch
6. Leaves you in main branch, ready for the next thing

### 4. `/worktree-list` - View and clean worktrees

```bash
/worktree-list              # View all active worktrees
/worktree-list cleanup      # Clean already merged worktrees
/worktree-list prune        # Clean obsolete references
```

---

## 🎓 Step-by-Step Tutorial

### Complete Example: Add JWT Authentication

#### Step 1: Create worktree

```bash
# From your main project
pwd  # /Users/you/myproject

# Smart mode - Claude helps
/worktree-start rails "Add JWT authentication with refresh tokens and remember me"
```

**Claude generates:**
- Branch name: `feat/jwt-auth-refresh-tokens`
- `FEATURE.md` with detailed checklist
- Suggestions of files to review first

#### Step 2: Work on the feature

```bash
# Navigate to new worktree
cd ../feat/jwt-auth-refresh-tokens

# Review generated guide
cat FEATURE.md

# Start coding
# ... create models, controllers, tests ...

# Frequent commits
git add .
git commit -m "[feat] Add JWT token model"
git commit -m "[feat] Add authentication controller"
git commit -m "[test] Add JWT auth tests"
```

#### Step 3: Review changes

```bash
# Before merge, always compare
/worktree-compare main
```

**Review carefully:**
- Do the changes make sense?
- Any unexpected files?
- Potential conflicts?
- Tests pass?
- Clean code without debugging statements?

#### Step 4: Run tests

```bash
# Rails
bin/rails test

# WordPress
vendor/bin/phpunit  # if configured
```

**Don't merge if tests fail.**

#### Step 5: Merge

```bash
# If everything is good
/worktree-merge main

# Confirm when asked
# The command does everything automatically
```

#### Step 6: Verify

```bash
# You should be back in main
pwd  # /Users/you/myproject
git branch --show-current  # main

# See that everything is merged
git log --oneline -5

# Worktree no longer exists
ls ../  # feat/jwt-auth-refresh-tokens is gone
```

---

## 💡 Common Use Cases

### Case 1: Work on Multiple Features Simultaneously

```bash
# Terminal 1: Large feature (takes days)
/worktree-start rails "Redesign entire dashboard with Tailwind"
cd ../feat/dashboard-redesign
# ... work in progress ...

# Terminal 2: Quick feature (takes hours)
/worktree-start rails "Add export to PDF button"
cd ../feat/pdf-export
# ... finish quickly ...
/worktree-merge main

# Terminal 1: Continue with dashboard without interruptions
# When done:
/worktree-merge main
```

### Case 2: Urgent Bug While Working on Feature

```bash
# You're in the middle of a feature
cd ../feat/big-feature
# ... uncommitted changes ...

# Urgent bug reported
# No need for stash!

# New terminal/tab
cd /path/to/main/project
/worktree-start rails "Fix critical login bug"
cd ../hotfix/critical-login-bug
# ... fix the bug ...
/worktree-merge main

# Original terminal: Still where you were
# No stash, no conflicts
```

### Case 3: Experiment Without Fear

```bash
# You want to try something but aren't sure
/worktree-start rails "Experiment with new UI library"
cd ../feat/experiment-ui-library

# Try, play, break things...
# Don't like the result?

# Easy: just don't merge
cd /path/to/main/project
rm -rf ../feat/experiment-ui-library
/worktree-list prune

# Your main project was never affected
```

### Case 4: Colleague Code Review

```bash
# Your colleague asks for review of their branch
/worktree-start rails colleague-feature-branch

# Review code locally
cd ../colleague-feature-branch
# ... review, run tests, etc ...

# Don't need to merge, just review
cd /path/to/main/project
rm -rf ../colleague-feature-branch
/worktree-list prune
```

---

## ⚠️ Common Errors and Solutions

### Error 1: "Branch already exists"

**Cause:** You already have a worktree with that name

**Solution:**
```bash
# View active worktrees
/worktree-list

# If already merged
/worktree-list cleanup

# If you want to delete specifically
git worktree remove /path/to/worktree
```

### Error 2: "You have uncommitted changes"

**Cause:** Trying to merge with uncommitted changes

**Solution:**
```bash
# Commit changes
git add .
git commit -m "Description of changes"

# Or stash if not ready
git stash

# Then retry merge
```

### Error 3: "Merge conflict"

**Cause:** Someone modified the same files

**Solution:**
```bash
# Merge stops, shows files in conflict
# Resolve manually:
# 1. Open files marked with <<<<<<<
# 2. Resolve conflicts
# 3. git add <resolved-files>
# 4. git commit
# 5. git push origin main
# 6. Manual cleanup of worktree
```

### Error 4: "Not in a worktree"

**Cause:** Trying to use `/worktree-compare` or `/worktree-merge` from main repo

**Solution:**
```bash
# Navigate to worktree first
cd ../your-feature-branch
/worktree-compare main
```

---

## 📖 Rails vs WordPress Differences

### Rails Projects

**Naming convention:**
- `feat/*` - New functionality
- `fix/*` - Bug fix
- `refactor/*` - Refactoring
- `test/*` - Tests
- `chore/*` - Maintenance

**Before merge, verify:**
```bash
bin/rails test          # Tests pass
bundle exec rubocop     # Linting OK
```

**Typical modified files:**
- `app/models/*`
- `app/controllers/*`
- `db/migrate/*`
- `config/routes.rb`
- `spec/` or `test/`

### WordPress Projects

**Naming convention:**
- `feature/*` - New functionality
- `bugfix/*` - Bug fix
- `enhancement/*` - Improvement
- `hotfix/*` - Critical fix

**Before merge, verify:**
```bash
npm run build           # Assets compiled
composer install        # Dependencies OK
vendor/bin/phpunit      # Tests (if configured)
```

**Typical modified files:**
- `app/themes/*` (WordPlate)
- `app/plugins/*`
- `resources/*` (Sage)
- `composer.json`
- `package.json`

---

## 🔥 Pro Tips

### Tip 1: Always Use Smart Mode

```bash
# ❌ Manual mode - no help
/worktree-start rails user-auth

# ✅ Smart mode - Claude helps you
/worktree-start rails "Add OAuth2 authentication with Google and GitHub"
```

**Why:** Claude generates better name, creates checklist, suggests files.

### Tip 2: Open Separate IDE/Terminal Per Worktree

```bash
# DON'T do this:
cd ../worktree1
# work...
cd ../worktree2
# work...
# CONFUSING!

# DO this:
# Terminal/IDE Window 1: worktree1
# Terminal/IDE Window 2: worktree2
# Each in its own space
```

### Tip 3: ALWAYS Compare Before Merge

```bash
# Correct flow:
/worktree-compare main  # Review changes
# Everything OK?
/worktree-merge main

# DON'T merge without comparing first
```

### Tip 4: Regular Cleanup

```bash
# Every Friday:
/worktree-list cleanup
/worktree-list prune

# Clean workspace for next week
```

### Tip 5: Short Features

**Golden rule:** Merge in 1-3 days maximum

- ✅ Small features: Fewer conflicts
- ✅ Easier review
- ✅ Continuous integration
- ❌ Long branches: More conflicts, difficult review

---

## 🎯 Checklist Before Your First Worktree

Before using worktrees for the first time:

- [ ] Installed commands: `./install.sh`
- [ ] In main project directory
- [ ] Working directory is clean or has stashed changes
- [ ] Know your main branch name (`main` or `master`)
- [ ] Have a specific feature in mind to work on

**Ready?** Run:

```bash
/worktree-start [rails|wp] "Your feature description"
```

---

## ❓ Quick FAQ

**Q: Can I have 10 worktrees open?**
A: Technically yes, but not recommended. 2-3 maximum to avoid confusion.

**Q: Do worktrees share the same .git?**
A: Yes, all point to the same repository but with different checkouts.

**Q: Can I push from a worktree?**
A: Yes, works exactly like a normal branch.

**Q: What happens if I manually delete a worktree?**
A: Git keeps references. Use `/worktree-list prune` to clean them.

**Q: Can I use worktrees with remote branches?**
A: Yes, you can create worktree from a remote branch.

**Q: What if two people work on the same branch?**
A: Same as normal branches: coordination and regular pull/push.

---

## 🚀 Next Steps

**Already read this?** Perfect. Now:

1. **Practice:** Create your first worktree with a real feature
2. **Reference:** Read [`CHEATSHEET.md`](./CHEATSHEET.md) for quick reference
3. **Deep dive:** Review [`README.md`](./README.md) for advanced details

**Complete documentation for each command:**
- [`worktree-start.md`](./worktree-start.md)
- [`worktree-compare.md`](./worktree-compare.md)
- [`worktree-merge.md`](./worktree-merge.md)
- [`worktree-list.md`](./worktree-list.md)

---

**Questions? Problems?** Open the relevant command above and look for the "Troubleshooting" section.

**Happy parallel development! 🚀**
