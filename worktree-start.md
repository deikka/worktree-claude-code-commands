---
description: Start parallel work on a feature using git worktree (Rails/PHP/Node/Python/Go/Rust)
allowed-tools: [bash_tool]
---

# Start Worktree for Feature

Initialize a new git worktree to work on a feature in parallel with your current work.

**Usage (Auto-detection - NEW!):** `/worktree-start "feature description"` (stack auto-detected)
**Alternative:** `/worktree-start <stack> "feature description"` (SMART MODE - manual stack)
**Manual:** `/worktree-start <stack> branch-name` (manual mode)
**Debug:** `/worktree-start -v "feature description"` (verbose mode - shows all commands)

**Arguments:**
- `$1`: (Optional) Project type/stack (`rails`, `php`, `node`/`js`/`ts`, `python`/`py`, `go`, `rust`, `generic`)
  - If omitted, stack is **auto-detected** based on project files
- `$2`: Feature description (quoted string) OR branch name (single word)
  - If `$1` is a description with spaces, stack is auto-detected

## Auto-Detection Mode (NEW!)

**AUTO-DETECTION MODE (Most Recommended):**
```bash
/worktree-start "Add JWT authentication with refresh tokens"
```
- **Stack is automatically detected** from project files (Gemfile, package.json, etc.)
- Claude analyzes your description
- Generates appropriate branch name automatically
- Creates FEATURE.md with context and suggestions
- Identifies relevant files to start with

## Smart Mode vs Manual Mode

**SMART MODE (Manual Stack):**
```bash
/worktree-start rails "Add JWT authentication with refresh tokens"
```
- Manually specify the stack
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
3. Project type is valid (see available stacks in `.worktree-config.json`)
4. Not already in a worktree directory
5. `.worktree-config.json` exists in repository root

## Process

### 1. Parse Debug/Verbose Flags

```bash
# Support for verbose mode: /worktree-start -v rails "feature"
VERBOSE=false
ORIGINAL_ARGS=("$@")

# Check for verbose flag in any position
for arg in "$@"; do
  if [[ "$arg" == "-v" || "$arg" == "--verbose" ]]; then
    VERBOSE=true
    # Remove verbose flag from arguments
    set -- "${@/$arg/}"
  fi
done

# Enable bash debugging if verbose mode
if [ "$VERBOSE" = true ]; then
  echo "🔍 Verbose mode enabled"
  set -x  # Show all commands being executed
fi
```

### 2. Validate Prerequisites and Git Repository

```bash
# Check git is installed
if ! command -v git &> /dev/null; then
  echo "❌ Error: git is not installed"
  echo "💡 Install git first:"
  echo "   macOS:  brew install git  or  xcode-select --install"
  echo "   Linux:  sudo apt-get install git  or  sudo yum install git"
  echo "   Manual: https://git-scm.com/downloads"
  exit 1
fi

# Check git version (worktrees require git 2.5+, recommend 2.15+)
GIT_VERSION=$(git --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
GIT_MAJOR=$(echo "$GIT_VERSION" | cut -d. -f1)
GIT_MINOR=$(echo "$GIT_VERSION" | cut -d. -f2)

if [ "$GIT_MAJOR" -lt 2 ] || ([ "$GIT_MAJOR" -eq 2 ] && [ "$GIT_MINOR" -lt 5 ]); then
  echo "❌ Error: git version too old ($GIT_VERSION)"
  echo "💡 git worktrees require git 2.5 or later"
  echo "   Current: $GIT_VERSION"
  echo "   Please upgrade git"
  exit 1
fi

if [ "$GIT_MAJOR" -eq 2 ] && [ "$GIT_MINOR" -lt 15 ]; then
  echo "⚠️  Warning: git $GIT_VERSION detected (works, but 2.15+ recommended)"
fi

# Verify not already in a worktree
CURRENT_GIT_DIR=$(git rev-parse --git-common-dir 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "❌ Error: Not in a git repository"
  echo "💡 Navigate to a git repository first"
  exit 1
fi

# Check if in a worktree (common-dir contains .git/worktrees/)
if [[ "$CURRENT_GIT_DIR" == *".git/worktrees"* ]]; then
  CURRENT_WORKTREE_BRANCH=$(git branch --show-current)
  # Get main repo path
  MAIN_REPO=$(echo "$CURRENT_GIT_DIR" | sed 's/\.git\/worktrees.*//')

  echo "❌ Error: You're already in a worktree"
  echo "📍 Current worktree: $CURRENT_WORKTREE_BRANCH"
  echo ""
  echo "💡 Navigate to the main repository first:"
  echo "   cd $MAIN_REPO"
  echo ""
  echo "Or finish/merge this worktree before creating a new one:"
  echo "   /worktree-merge"
  exit 1
fi

echo "✅ Running from main repository"
```

### 3. Parse Arguments and Detect Mode

```bash
# Validate .worktree-config.json exists
if [ ! -f ".worktree-config.json" ]; then
  echo "❌ Error: .worktree-config.json not found"
  echo "💡 Run this from repository root or create config file"
  exit 1
fi

# Check jq is available (required for auto-detection)
if ! command -v jq &> /dev/null; then
  echo "⚠️  Warning: jq not installed"
  echo "💡 For auto-detection and full stack support, install jq:"
  echo "   macOS:  brew install jq"
  echo "   Linux:  sudo apt-get install jq  or  sudo yum install jq"
  echo "   Manual: https://stedolan.github.io/jq/download/"
  echo ""
fi

# Determine if first argument is a stack or a feature description
ARG1="$1"
ARG2="${2:-}"

# Auto-detection logic:
# - If ARG1 contains spaces → it's a description, auto-detect stack
# - If ARG1 is a known stack → use it, ARG2 is description/branch
# - If ARG1 is unknown → try auto-detection

AUTO_DETECT=false
PROJECT_TYPE=""
FEATURE_INPUT=""

# Check if ARG1 looks like a description (contains spaces or quotes)
if [[ "$ARG1" =~ [[:space:]] ]]; then
  # ARG1 is a description → auto-detect stack
  AUTO_DETECT=true
  FEATURE_INPUT="$ARG1"
  echo "🔍 Auto-detection mode: No stack specified"
else
  # ARG1 might be a stack name or a branch name
  # Check if it's a known stack
  if command -v jq &> /dev/null; then
    AVAILABLE_STACKS=$(jq -r '.stacks | keys[]' .worktree-config.json 2>/dev/null)

    # Map common aliases to full stack names
    NORMALIZED_ARG1="$ARG1"
    case "$ARG1" in
      js|ts|javascript|typescript) NORMALIZED_ARG1="node" ;;
      py) NORMALIZED_ARG1="python" ;;
    esac

    # Check if it's a valid stack
    if echo "$AVAILABLE_STACKS" | grep -q "^${NORMALIZED_ARG1}$"; then
      # It's a valid stack
      PROJECT_TYPE="$NORMALIZED_ARG1"
      FEATURE_INPUT="$ARG2"

      if [ -z "$FEATURE_INPUT" ]; then
        echo "❌ Error: Missing feature description or branch name"
        echo "💡 Usage: /worktree-start $ARG1 \"feature description\""
        exit 1
      fi
    else
      # Not a known stack → try auto-detection
      AUTO_DETECT=true
      FEATURE_INPUT="$ARG1"
      echo "🔍 Auto-detection mode: '$ARG1' is not a known stack"
    fi
  else
    # No jq → fallback to basic validation
    if [[ "$ARG1" != "rails" && "$ARG1" != "php" ]]; then
      echo "❌ Error: Project type must be 'rails' or 'php' (or install jq for auto-detection)"
      exit 1
    fi
    PROJECT_TYPE="$ARG1"
    FEATURE_INPUT="$ARG2"
  fi
fi

# Perform auto-detection if needed
if [ "$AUTO_DETECT" = true ]; then
  if [ ! -f "lib/detect-stack.sh" ]; then
    echo "❌ Error: Auto-detection script not found"
    echo "💡 Please specify the stack manually: /worktree-start <stack> \"description\""
    exit 1
  fi

  echo "🔍 Detecting project stack..."

  # Source the detection script and run detection
  export VERBOSE="$VERBOSE"
  export WORKTREE_CONFIG_FILE=".worktree-config.json"

  DETECTED_STACK=$(bash lib/detect-stack.sh 2>/dev/null)

  if [ $? -ne 0 ] || [ -z "$DETECTED_STACK" ]; then
    echo "❌ Error: Could not auto-detect project stack"
    echo "💡 Please specify the stack manually:"
    echo "   /worktree-start <stack> \"$FEATURE_INPUT\""
    echo ""
    echo "📋 Available stacks:"
    if command -v jq &> /dev/null; then
      jq -r '.stacks | keys[]' .worktree-config.json | sed 's/^/  - /'
    else
      echo "  - rails"
      echo "  - php"
    fi
    exit 1
  fi

  PROJECT_TYPE="$DETECTED_STACK"
  STACK_NAME=$(jq -r ".stacks[\"$PROJECT_TYPE\"].name" .worktree-config.json)
  echo "✅ Detected stack: $STACK_NAME ($PROJECT_TYPE)"
fi

# Validate we have both stack and feature input
if [ -z "$PROJECT_TYPE" ]; then
  echo "❌ Error: Project type not specified and auto-detection failed"
  exit 1
fi

if [ -z "$FEATURE_INPUT" ]; then
  echo "❌ Error: Feature description or branch name required"
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

### 4. Smart Mode: Generate Branch Name

**Only if MODE="smart":**

```bash
# Ask Claude to generate an appropriate branch name
echo "Analyzing: '$FEATURE_DESCRIPTION'"
echo ""
echo "Please generate a git branch name following these rules:"
echo "- Rails projects: feat/*, fix/*, refactor/* prefix"
echo "- PHP projects: feat/*, fix/*, refactor/* prefix (customizable per framework)"
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
- PHP: `feat/jwt-auth-system` or `fix/login-validation`

**CRITICAL:** After Claude generates the branch name, validate it programmatically:

```bash
# Store result in $BRANCH_NAME (received from Claude's response)
# Example: BRANCH_NAME="feat/jwt-authentication-refresh"

# Validate branch name is not empty
if [ -z "$BRANCH_NAME" ]; then
  echo "❌ Error: No branch name generated"
  echo "💡 Please provide a feature description or use manual mode"
  exit 1
fi

# Validate format (lowercase alphanumeric with /-_ only)
if ! [[ "$BRANCH_NAME" =~ ^[a-z0-9/_-]+$ ]]; then
  echo "❌ Error: Invalid branch name format: $BRANCH_NAME"
  echo "💡 Branch names must be lowercase alphanumeric with /-_ only"
  echo "   Example: feat/user-authentication"
  exit 1
fi

# Validate length
if [ ${#BRANCH_NAME} -gt 50 ]; then
  echo "❌ Error: Branch name too long (${#BRANCH_NAME} chars, max 50)"
  echo "💡 Try a more concise description"
  exit 1
fi

if [ ${#BRANCH_NAME} -lt 5 ]; then
  echo "❌ Error: Branch name too short (${#BRANCH_NAME} chars, min 5)"
  exit 1
fi

echo "✅ Generated branch name: $BRANCH_NAME"
```

Store validated result in `$BRANCH_NAME`

### 5. Validate Branch Doesn't Exist

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

### 6. Save Current State

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

### 7. Create Worktree

```bash
# Get worktree base path from config (default to parent directory)
if command -v jq &> /dev/null && [ -f ".worktree-config.json" ]; then
  WORKTREE_BASE=$(jq -r '.defaults.worktree_base // ".."' .worktree-config.json)
else
  WORKTREE_BASE=".."
fi

# Build full worktree path
WORKTREE_PATH="$WORKTREE_BASE/$BRANCH_NAME"

echo "🌿 Creating new worktree at $WORKTREE_PATH"
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"

if [ $? -ne 0 ]; then
  echo "❌ Failed to create worktree"
  echo "💡 Check that the path is valid and accessible"
  exit 1
fi

echo "✅ Worktree created at: $WORKTREE_PATH"
```

### 8. Smart Mode: Generate FEATURE.md

**Only if MODE="smart":**

```bash
cd "$WORKTREE_PATH"

cat > FEATURE.md << EOF
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

For PHP projects (WordPress, Laravel, etc.), typically include:
- [ ] Create/modify relevant files (controllers, models, views, etc.)
- [ ] Add database migrations/tables (if needed)
- [ ] Implement admin interfaces (if applicable)
- [ ] Add frontend templates/views
- [ ] Create API endpoints (if needed)
- [ ] Write tests
- [ ] Update documentation

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

### 9. Setup Branch Tracking

```bash
# Set upstream tracking
echo "📤 Pushing branch to remote..."
if git push -u origin "$BRANCH_NAME" 2>&1; then
  echo "✅ Branch pushed to origin"
else
  EXIT_CODE=$?
  echo ""
  echo "⚠️  Warning: Could not push to remote (exit code: $EXIT_CODE)"
  echo "💡 This is not critical - you can push later with:"
  echo "   git push -u origin $BRANCH_NAME"
  echo ""
  echo "Common causes:"
  echo "  - No internet connection"
  echo "  - Remote repository not configured"
  echo "  - Insufficient permissions"
  echo ""
fi

echo "✅ Worktree created successfully!"
```

### 10. Final Instructions

```bash
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Worktree Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 New worktree location: $WORKTREE_PATH"
echo "🌿 Branch: $BRANCH_NAME"
echo "📍 Current location remains: $CURRENT_BRANCH"
echo ""
if [ "$MODE" = "smart" ]; then
  echo "📝 Review FEATURE.md for implementation guidance"
  echo ""
fi
echo "🔄 To switch between worktrees:"
echo "   cd $WORKTREE_PATH     # Work on new feature"
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

### PHP Projects

**Prefix conventions:**
- `feat/*` - New features (default)
- `fix/*` - Bug fixes
- `refactor/*` - Code refactoring
- `hotfix/*` - Critical fixes

**Note:** PHP projects can be customized per framework using `.worktree-config.local.json`. See `.worktree-config.examples.json` for WordPress, Laravel, Symfony configurations.

**Common directories to check:**
- `src/` or `app/` - Application code
- `tests/` - Tests
- `composer.json` - Dependencies
- Framework-specific directories (themes, plugins, migrations, etc.)

## Best Practices

1. **One feature per worktree:** Don't try to work on multiple unrelated features in the same worktree

2. **Keep worktrees short-lived:** Merge within 1-3 days to avoid conflicts

3. **Regular commits:** Commit frequently within your worktree

4. **Compare before merging:** Always use `/worktree-compare` before merging

5. **Clean up promptly:** Use `/worktree-merge` which auto-cleans, or manually with `/worktree-list cleanup`

6. **Open new terminal/IDE:** Don't try to navigate between worktrees in the same terminal session - it's confusing

## Example Workflows

### Auto-Detection Mode (Most Recommended):

```bash
# Start - Stack is automatically detected!
/worktree-start "Add two-factor authentication with SMS and email"
# 🔍 Detecting project stack...
# ✅ Detected stack: Ruby on Rails (rails)
# Claude generates: feat/two-factor-auth-sms-email
# Creates FEATURE.md with implementation guidance

cd ../feat/two-factor-auth-sms-email
# Review FEATURE.md
# Start coding following the generated checklist

# When done
/worktree-compare main
/worktree-merge main
```

### Smart Mode Example (Manual Stack):

```bash
# Start - Manually specify stack
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
/worktree-start php user-profile-redesign
# Uses exact branch name: feat/user-profile-redesign

cd ../feat/user-profile-redesign
# Start coding immediately

# When done
/worktree-compare main
/worktree-merge main
```

### Parallel Development with Auto-Detection:

```bash
# Terminal 1: Work on authentication
/worktree-start "OAuth2 integration"
cd ../feat/oauth2-integration

# Terminal 2: Work on UI simultaneously
/worktree-start "Dashboard redesign with Tailwind"
cd ../feat/dashboard-redesign

# Both can be developed, tested, and merged independently
# Stack is auto-detected for each worktree based on project files
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
