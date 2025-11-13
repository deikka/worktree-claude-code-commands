---
description: Start parallel work on a feature using git worktree (Rails/WordPress)
allowed-tools: [bash_tool]
---

# Start Worktree for Feature

Initialize a new git worktree to work on a feature in parallel with your current work.

**Usage:** `/worktree-start [rails|wp] "feature description"` (SMART MODE - recommended)
**Alternative:** `/worktree-start [rails|wp] branch-name` (manual mode)

**Arguments:**
- `$1`: Project type (`rails` or `wp`)
- `$2`: Feature description (quoted string) OR branch name (single word)

## Smart Mode vs Manual Mode

**SMART MODE (Recommended):**
```bash
/worktree-start rails "Add JWT authentication with refresh tokens"
```
- Claude analyzes your description
- Generates appropriate branch name automatically
- Creates FEATURE.md with context and suggestions
- Identifies relevant files to start with

**MANUAL MODE:**
```bash
/worktree-start rails user-authentication
```
- Uses provided branch name directly
- No AI analysis or suggestions
- Faster but less guidance

## Validation

**CRITICAL:** Before proceeding, verify:
1. Working directory is clean or has stashable changes
2. Feature description/name is provided and valid
3. Project type is either 'rails' or 'wp'
4. Not already in a worktree directory

## Process

### 1. Parse Arguments and Detect Mode

```bash
PROJECT_TYPE="$1"
FEATURE_INPUT="$2"

# Validate project type
if [[ "$PROJECT_TYPE" != "rails" && "$PROJECT_TYPE" != "wp" ]]; then
  echo "❌ Error: Project type must be 'rails' or 'wp'"
  exit 1
fi

# Detect mode: if input contains spaces or special chars, it's smart mode
if [[ "$FEATURE_INPUT" =~ [[:space:]] ]]; then
  MODE="smart"
  FEATURE_DESCRIPTION="$FEATURE_INPUT"
  echo "🤖 Smart Mode: Analyzing feature description..."
else
  MODE="manual"
  BRANCH_NAME="$FEATURE_INPUT"
  echo "⚡ Manual Mode: Using provided branch name..."
fi
```

### 2. Smart Mode: Generate Branch Name

**Only if MODE="smart":**

```bash
# Ask Claude to generate an appropriate branch name
echo "Analyzing: '$FEATURE_DESCRIPTION'"
echo ""
echo "Please generate a git branch name following these rules:"
echo "- Rails projects: feat/*, fix/*, refactor/* prefix"
echo "- WordPress projects: feature/*, bugfix/*, enhancement/* prefix"
echo "- Lowercase, hyphens only, max 50 chars"
echo "- Descriptive but concise"
echo ""
echo "Feature description: $FEATURE_DESCRIPTION"
echo "Project type: $PROJECT_TYPE"
echo ""
echo "Respond with ONLY the branch name, nothing else."
```

**Expected output format:**
- Rails: `feat/jwt-authentication-refresh` or `fix/auth-token-expiry`
- WordPress: `feature/jwt-auth-system` or `bugfix/login-validation`

**CRITICAL:** Claude must validate the generated name:
- Matches project type prefix
- Is lowercase with hyphens only
- Is between 10-50 characters
- Is descriptive and clear

Store result in `$BRANCH_NAME`

### 3. Validate Branch Doesn't Exist

```bash
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  echo "❌ Error: Branch '$BRANCH_NAME' already exists"
  echo "💡 Tip: Use a different name or delete the existing branch first"
  exit 1
fi

if [ -d "../$BRANCH_NAME" ]; then
  echo "❌ Error: Worktree directory '../$BRANCH_NAME' already exists"
  exit 1
fi
```

### 4. Save Current State

```bash
CURRENT_BRANCH=$(git branch --show-current)
REPO_ROOT=$(git rev-parse --show-toplevel)

echo "📍 Current location: $REPO_ROOT ($CURRENT_BRANCH)"

# Stash if there are changes
if ! git diff-index --quiet HEAD --; then
  echo "💾 Stashing current changes..."
  git stash push -m "Auto-stash before creating worktree $BRANCH_NAME"
fi
```

### 5. Create Worktree

```bash
echo "🌿 Creating new worktree at ../$BRANCH_NAME"
git worktree add -b "$BRANCH_NAME" "../$BRANCH_NAME"

if [ $? -ne 0 ]; then
  echo "❌ Failed to create worktree"
  exit 1
fi
```

### 6. Smart Mode: Generate FEATURE.md

**Only if MODE="smart":**

```bash
cd "../$BRANCH_NAME"

cat > FEATURE.md << 'EOF'
# Feature: $FEATURE_DESCRIPTION

**Branch:** $BRANCH_NAME
**Type:** $PROJECT_TYPE
**Created:** $(date +"%Y-%m-%d %H:%M")

## 🎯 Objective

[Claude: Based on the description, explain what this feature aims to accomplish]

## 📋 Implementation Checklist

[Claude: Generate a practical checklist based on the description and project type]

For Rails projects, typically include:
- [ ] Create/modify models
- [ ] Add database migrations
- [ ] Implement controller actions
- [ ] Add routes
- [ ] Create/update views (if needed)
- [ ] Write tests (model, controller, integration)
- [ ] Update documentation

For WordPress projects, typically include:
- [ ] Create/modify plugin files
- [ ] Add database tables/fields (if needed)
- [ ] Implement admin interfaces
- [ ] Add frontend templates
- [ ] Create REST API endpoints (if needed)
- [ ] Write tests
- [ ] Update plugin documentation

## 🔍 Files to Review First

[Claude: Analyze the project structure and suggest 5-10 relevant files to start with]

## 💡 Implementation Notes

[Claude: Add specific notes based on the description, e.g., security considerations, 
performance implications, testing strategies, etc.]

## 🚀 Getting Started

1. Review the files listed above
2. Start with tests (TDD approach)
3. Implement core functionality
4. Add edge case handling
5. Update documentation
6. Run full test suite before committing

## 📚 References

[Claude: Add relevant documentation links, similar implementations in the codebase, 
or external resources]
EOF

echo "📝 Created FEATURE.md with implementation guidance"
```

**CRITICAL for Claude:** 
- Actually analyze the project structure using available tools
- Be specific with file paths, not generic placeholders
- Include real examples from the codebase when possible
- Adapt checklist to the actual feature complexity

### 7. Setup Branch Tracking

```bash
# Set upstream tracking
git push -u origin "$BRANCH_NAME"

echo "✅ Worktree created successfully!"
```

### 8. Final Instructions

```bash
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Worktree Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 New worktree location: ../$BRANCH_NAME"
echo "🌿 Branch: $BRANCH_NAME"
echo "📍 Current location remains: $CURRENT_BRANCH"
echo ""
if [ "$MODE" = "smart" ]; then
  echo "📝 Review FEATURE.md for implementation guidance"
  echo ""
fi
echo "🔄 To switch between worktrees:"
echo "   cd ../$BRANCH_NAME     # Work on new feature"
echo "   cd $REPO_ROOT          # Back to main workspace"
echo ""
echo "📊 Compare changes later with:"
echo "   /worktree-compare $CURRENT_BRANCH"
echo ""
echo "🔗 Merge when ready with:"
echo "   /worktree-merge $CURRENT_BRANCH"
echo ""
echo "💡 Pro tip: Open a new terminal/IDE window for each worktree"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## Error Handling

**Common errors to handle gracefully:**

1. **Not in a git repository:**
   ```bash
   if ! git rev-parse --git-dir > /dev/null 2>&1; then
     echo "❌ Error: Not in a git repository"
     exit 1
   fi
   ```

2. **Already in a worktree:**
   ```bash
   if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
     WORKTREE_DIR=$(git rev-parse --git-common-dir)
     if [[ "$WORKTREE_DIR" == *".git/worktrees"* ]]; then
       echo "❌ Error: You're already in a worktree"
       echo "💡 Tip: Navigate to the main repository first"
       exit 1
     fi
   fi
   ```

3. **Untracked files that would be overwritten:**
   ```bash
   # This is handled automatically by git worktree add
   # but we should inform the user if it fails
   ```

## Stack-Specific Considerations

### Rails Projects

**Prefix conventions:**
- `feat/*` - New features
- `fix/*` - Bug fixes
- `refactor/*` - Code improvements
- `test/*` - Test additions/improvements
- `chore/*` - Maintenance tasks

**Common directories to check:**
- `app/models/` - Model changes
- `app/controllers/` - Controller logic
- `db/migrate/` - Database migrations
- `spec/` or `test/` - Tests
- `config/routes.rb` - Routing changes

### WordPress Projects

**Prefix conventions:**
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `enhancement/*` - Improvements
- `hotfix/*` - Critical fixes

**Common directories to check:**
- `app/themes/` (WordPlate) - Theme files
- `app/plugins/` (WordPlate) - Plugin code
- `resources/` - Assets (if using Sage)
- `config/` - WordPress configuration
- `tests/` - Tests

## Best Practices

1. **One feature per worktree:** Don't try to work on multiple unrelated features in the same worktree

2. **Keep worktrees short-lived:** Merge within 1-3 days to avoid conflicts

3. **Regular commits:** Commit frequently within your worktree

4. **Compare before merging:** Always use `/worktree-compare` before merging

5. **Clean up promptly:** Use `/worktree-merge` which auto-cleans, or manually with `/worktree-list cleanup`

6. **Open new terminal/IDE:** Don't try to navigate between worktrees in the same terminal session - it's confusing

## Example Workflows

### Smart Mode Example (Recommended):

```bash
# Start
/worktree-start rails "Add two-factor authentication with SMS and email"
# Claude generates: feat/two-factor-auth-sms-email
# Creates FEATURE.md with implementation guidance

cd ../feat/two-factor-auth-sms-email
# Review FEATURE.md
# Start coding following the generated checklist

# When done
/worktree-compare main
/worktree-merge main
```

### Manual Mode Example:

```bash
# Start
/worktree-start wp user-profile-redesign
# Uses exact branch name: user-profile-redesign

cd ../user-profile-redesign
# Start coding immediately

# When done
/worktree-compare main
/worktree-merge main
```

### Parallel Development:

```bash
# Terminal 1: Work on authentication
/worktree-start rails "OAuth2 integration"
cd ../feat/oauth2-integration

# Terminal 2: Work on UI simultaneously
/worktree-start rails "Dashboard redesign with Tailwind"
cd ../feat/dashboard-redesign

# Both can be developed, tested, and merged independently
```

## What Happens Next

After running this command:

1. ✅ New worktree is created in a sibling directory
2. ✅ New branch is created and checked out in that worktree
3. ✅ (Smart mode) FEATURE.md is generated with context
4. ✅ Branch is tracked on remote
5. ✅ Your original worktree remains untouched
6. ✅ Clear instructions printed for next steps

**You can now:**
- Open the new worktree in a separate terminal/IDE window
- Work on the feature independently
- Run tests, make commits, push changes
- Compare with main branch using `/worktree-compare`
- Merge when ready using `/worktree-merge`

**Important:** The original terminal/working directory is unchanged. You're still in your main workspace and can continue working there.
