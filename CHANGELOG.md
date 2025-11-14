# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

No unreleased changes yet.

---

## [1.1.0] - 2025-01-14

### 🐛 Fixed

#### Bug #1 - CRITICAL: Heredoc variable expansion in FEATURE.md
- **File:** `worktree-start.md:151`
- **Problem:** Variables were not expanding in FEATURE.md due to single quotes in heredoc (`<< 'EOF'`)
- **Fix:** Removed single quotes from EOF delimiter to allow variable expansion
- **Impact:** Smart mode now correctly generates FEATURE.md with actual values instead of literal variable names

#### Bug #2: Multi-stack support validation
- **File:** `worktree-start.md:53-88`
- **Problem:** Hard-coded validation only allowed `rails` or `wp`, despite 7 stacks being configured
- **Fix:** Dynamic validation reads available stacks from `.worktree-config.json` using `jq`
- **Added:** Support for stack aliases (wp→wordpress, js/ts→node, py→python)
- **Impact:** All 7 configured stacks (rails, wordpress, node, python, go, rust, generic) now work

#### Bug #3: Silent push failures
- **File:** `worktree-start.md:253-272`
- **Problem:** `git push` could fail silently without user notification
- **Fix:** Added proper error handling with informative messages
- **Impact:** Users are notified if push fails and given troubleshooting guidance

#### Bug #4: Incorrect REPO_ROOT calculation
- **File:** `worktree-merge.md:130-147`
- **Problem:** `sed` pattern didn't reliably extract main repo path from worktree
- **Fix:** Use `git rev-parse --git-common-dir` with proper path manipulation
- **Impact:** Merge command reliably navigates to main repository from any worktree

#### Bug #5: Lost counter in cleanup loop
- **File:** `worktree-list.md:106-131`
- **Problem:** Counter variable changes lost due to pipe creating subshell
- **Fix:** Use here-string (`<<< "$MERGED_BRANCHES"`) instead of pipe to preserve variable scope
- **Impact:** Cleanup command now correctly reports number of removed worktrees

#### Bug #6: Missing "already in worktree" validation
- **File:** `worktree-start.md:71-127`
- **Problem:** No validation prevented running from inside a worktree
- **Fix:** Added check for `.git/worktrees` in `git-common-dir` with helpful error message
- **Impact:** Clear error when attempting to create worktree from within another worktree

#### Bug #7: No validation of generated branch names
- **File:** `worktree-start.md:127-163`
- **Problem:** Claude-generated branch names weren't validated before use
- **Fix:** Added comprehensive validation (empty check, format, length constraints)
- **Impact:** Invalid branch names are caught early with clear error messages

### ✨ Added

#### Feature: Stack aliases
- **Files:** `worktree-start.md:135-138`
- **Description:** Common aliases automatically map to full stack names
- **Aliases:**
  - `wp` → `wordpress`
  - `js`, `ts`, `javascript`, `typescript` → `node`
  - `py` → `python`
- **Impact:** More intuitive command usage

#### Feature: Local configuration example
- **Files:** `.worktree-config.local.json.example`, `.gitignore`
- **Description:** Example file for per-developer custom configurations
- **Features:**
  - Custom stack definitions
  - Override default settings
  - Commented with usage instructions
- **Impact:** Easy project-specific customization without modifying main config

#### Feature: Configurable worktree path
- **Files:**
  - `.worktree-config.json:148` (new `worktree_base` setting)
  - `worktree-start.md:230-250`
- **Description:** Worktree creation path now configurable via `defaults.worktree_base`
- **Default:** `..` (sibling directory, maintains backward compatibility)
- **Impact:** Teams can standardize worktree locations (e.g., `/Users/dev/worktrees`)

#### Feature: Verbose/debug mode
- **File:** `worktree-start.md:48-68`
- **Usage:** `/worktree-start -v <stack> "feature"`
- **Description:** Enables bash debugging (`set -x`) to show all executed commands
- **Impact:** Easier troubleshooting and understanding of command execution

#### Feature: Comprehensive prerequisite validation
- **File:** `worktree-start.md:71-127`
- **Validations:**
  - Git installation check
  - Git version check (requires 2.5+, recommends 2.15+)
  - Repository validation
  - Worktree context validation
  - jq availability (with helpful installation instructions)
- **Impact:** Better error messages guide users to fix issues

### 📚 Improved

#### Documentation: Updated usage examples
- **Files:** `worktree-start.md:10-16`
- **Changes:**
  - Added all supported stacks to usage documentation
  - Added verbose mode usage example
  - Clarified stack aliases in arguments list

#### Documentation: Updated validation section
- **File:** `worktree-start.md:38-44`
- **Changes:**
  - Added `.worktree-config.json` existence check to validation list
  - Updated stack validation description to reference config file

#### Code: Better error messages
- **Files:** Multiple command files
- **Changes:**
  - Added installation instructions for missing tools (git, jq)
  - Platform-specific install commands (macOS, Linux)
  - Links to download pages
  - Contextual tips for common issues

#### Structure: Process section renumbering
- **File:** `worktree-start.md`
- **Changes:** Renumbered process steps 1-10 for consistency
  1. Parse Debug/Verbose Flags
  2. Validate Prerequisites and Git Repository
  3. Parse Arguments and Detect Mode
  4. Smart Mode: Generate Branch Name
  5. Validate Branch Doesn't Exist
  6. Save Current State
  7. Create Worktree
  8. Smart Mode: Generate FEATURE.md
  9. Setup Branch Tracking
  10. Final Instructions

### 🔧 Changed

#### Configuration: Added worktree_base to defaults
- **File:** `.worktree-config.json:148`
- **Change:** Added `"worktree_base": ".."` to defaults
- **Reason:** Support configurable worktree creation path
- **Backward Compatible:** Yes (defaults to previous behavior)

#### Git Ignore: Added local config file
- **File:** `.gitignore:34`
- **Change:** Added `.worktree-config.local.json` to ignore list
- **Reason:** Per-developer settings shouldn't be committed

### 📊 Statistics

- **Bugs Fixed:** 7 (1 critical, 6 minor)
- **Features Added:** 5
- **Files Modified:** 5
- **Files Created:** 2
- **Lines Changed:** ~350+
- **Documentation Updates:** Multiple sections across 3 command files

### 🔄 Migration Notes

#### For Existing Users

No breaking changes. All modifications are backward compatible:

- Old commands continue to work exactly as before
- New features are opt-in
- Default behavior unchanged

#### Optional Upgrades

1. **Install jq** for full multi-stack support:
   ```bash
   brew install jq  # macOS
   sudo apt-get install jq  # Linux
   ```

2. **Create local config** for custom settings:
   ```bash
   cp .worktree-config.local.json.example .worktree-config.local.json
   # Edit as needed
   ```

3. **Use verbose mode** for troubleshooting:
   ```bash
   /worktree-start -v rails "feature description"
   ```

### 🎯 Next Steps

Completed improvements:
- ✅ All critical bugs fixed
- ✅ All minor bugs fixed
- ✅ All planned improvements implemented
- ✅ Documentation updated

Project is now ready for:
- Integration testing
- User feedback
- Documentation review
- Release v1.1.0

---

## [1.0.0] - 2024-11-13

Initial release with core worktree management functionality.

### Features
- `/worktree-start` - Create worktrees with smart/manual modes
- `/worktree-compare` - Compare changes before merging
- `/worktree-merge` - Merge and cleanup worktrees
- `/worktree-list` - List and manage active worktrees
- Support for Rails and WordPress stacks
- Bilingual documentation (English/Spanish)
- GitHub release automation
- Comprehensive testing framework
