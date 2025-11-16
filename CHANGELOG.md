# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

---

## [1.2.0] - 2025-11-14

### ✨ Added

#### Feature: Visual Diff Tool Integration
- **File:** `lib/visual-diff.sh` (NEW)
- **Description:** Integration with popular visual diff tools for better code review
- **Supported Tools:**
  - VS Code (`code --diff`)
  - Meld (cross-platform)
  - KDiff3 (cross-platform)
  - FileMerge / opendiff (macOS with Xcode)
  - Beyond Compare
  - Diffuse, Kompare (Linux)
  - Vimdiff (terminal-based fallback)
  - Git's configured difftool
- **Features:**
  - Auto-detection of available tools on system
  - Interactive tool selection with descriptions
  - Preference saving to `.worktree-config.local.json`
  - File-by-file comparison mode
  - Interactive multi-select for specific files
  - Integration with `worktree-compare` command
- **Usage:**
  ```bash
  # Visual comparison (all files)
  /worktree-compare -v main

  # Interactive file selection
  /worktree-compare -i main

  # Standalone tool selection
  bash lib/visual-diff.sh select
  ```
- **Configuration:**
  - Added `visual_diff_tool` and `visual_diff_enabled` to `.worktree-config.json`
  - Tool preference saved to local config
  - Supports custom difftool configuration
- **Impact:** Better code review experience with familiar visual tools

#### Feature: Interactive Mode
- **File:** `lib/interactive-prompt.sh` (NEW)
- **Description:** Guided interactive mode for worktree creation with visual prompts
- **Features:**
  - Arrow key navigation for menu selection
  - Visual change type picker (feature/bugfix/hotfix/refactor/docs/test/chore)
  - Branch name preview and editing
  - Final confirmation with summary
  - Color-coded output with boxes and icons
- **Usage:**
  ```bash
  /worktree-start -i "Add authentication feature"
  ```
- **Interactive Components:**
  - `select_option()` - Arrow key menu with visual cursor
  - `confirm()` - Yes/No prompts with defaults
  - `prompt_input()` - Text input with defaults
  - `multi_select()` - Checkbox-style multi-selection
  - `box()` - Decorative boxes for headings
  - `info/success/warn/error()` - Colored status messages
- **Impact:** Perfect for beginners, reduces errors, teaches the system

#### Feature: Automatic Stack Detection
- **File:** `lib/detect-stack.sh` (NEW)
- **Description:** Automatically detects project stack based on files present in repository
- **Detection Patterns:**
  - **Rails**: Gemfile + optional config/application.rb or app/models/
  - **PHP**: composer.json + optional index.php, src/, or public/themes/
  - **Node.js**: package.json + optional node_modules/ or tsconfig.json
  - **Python**: One of: requirements.txt, setup.py, pyproject.toml, or Pipfile
  - **Go**: go.mod + optional go.sum
  - **Rust**: Cargo.toml + optional Cargo.lock
  - **Generic**: Fallback when no stack matches
- **Priority System:** Each stack has configurable priority (0-100) for ambiguous projects
- **Usage:**
  ```bash
  # Auto-detect stack
  /worktree-start "Add new feature"

  # Manual override still available
  /worktree-start rails "Add new feature"
  ```
- **Impact:** Simpler command syntax, no need to remember/specify stack type

#### Configuration: Detection patterns in config
- **File:** `.worktree-config.json`
- **Changes:**
  - Added `detection_patterns` array to each stack
  - Added `detection_priority` (0-100, higher = preferred)
  - Added optional `detection_note` for documentation
- **Pattern Types:**
  - `file` - Check for file existence
  - `directory` - Check for directory existence
  - Each pattern can be `required: true/false`
- **Impact:** Customizable detection behavior per stack

#### Integration: Visual diff in worktree-compare
- **File:** `worktree-compare.md`
- **Changes:**
  - Added `-v` / `--visual` flag for automatic visual diff
  - Added `-i` / `--interactive` flag for file selection
  - Integration with `lib/visual-diff.sh` for tool management
  - Multi-select interface for choosing specific files to compare
  - Fallback to git difftool for directory-level comparison
  - Temporary file creation for version comparison
  - Automatic cleanup of temp files
  - Tool preference loading and saving
- **Visual Diff Flow:**
  1. Parse visual diff flags
  2. Load visual-diff.sh helper
  3. Get list of changed files
  4. Interactive mode: Show multi-select menu
  5. For each selected file: Create temp files from both branches
  6. Launch configured visual diff tool
  7. Clean up temp files
- **Impact:** Dramatically improved code review experience with side-by-side comparison

#### Integration: Interactive and Auto-detection in worktree-start
- **File:** `worktree-start.md`
- **Changes:**
  - Added `-i` / `--interactive` flag support
  - Stack parameter is now optional
  - Detects if first argument is stack name or feature description
  - Calls `lib/detect-stack.sh` when needed
  - Interactive mode flow:
    1. Load interactive prompt helpers
    2. Select change type from available branch patterns
    3. Generate branch name with change type context
    4. Preview and allow editing of branch name
    5. Show summary before creation
    6. Confirm before creating worktree
  - Shows detection result to user
  - Graceful fallback to manual mode on detection failure
- **Compatibility:** All existing commands continue to work
- **Impact:** Backward compatible enhancement with better UX and learning curve

### 📚 Improved

#### Documentation: Visual diff, interactive mode, and auto-detection
- **Files:** `README.md`, `worktree-start.md`, `worktree-compare.md`
- **Changes:**
  - Updated "What's New" section with all v1.2.0 features
  - Added visual diff integration documentation
  - Listed supported diff tools with examples
  - Added interactive mode examples with full workflow
  - Added auto-detection examples to Quick Start
  - Updated command syntax documentation for all commands
  - Added visual detection and interactive output examples
  - Created comprehensive "Example Workflows" section showing:
    - Visual diff mode (interactive file selection)
    - Interactive worktree mode (best for beginners)
    - Auto-detection mode (best for speed)
    - Smart mode (manual stack control)
    - Manual mode (direct branch naming)
  - Updated worktree-compare documentation with visual diff flags
  - Added tool detection and preference saving examples
- **Impact:** Clear documentation of all new features with visual examples and workflows

---

## [1.1.1] - 2025-01-14

### 🔧 Changed

#### Stack rename: WordPress → PHP
- **Files:** `.worktree-config.json`, all documentation files
- **Change:** Renamed `wordpress` stack to `php` for better generalizability
- **Reason:** PHP is more generic and applicable to multiple frameworks (WordPress, Laravel, Symfony, etc.)
- **Migration:**
  - Base stack is now `php` with generic conventions (`feat/*`, `fix/*`, etc.)
  - Framework-specific configurations available in `.worktree-config.examples.json`
  - Users can customize via `.worktree-config.local.json`
- **Backward Compatibility:** Users need to update from `wordpress`/`wp` to `php`
- **Impact:** Better framework support and clearer naming

### ✨ Added

#### Feature: PHP framework example configurations
- **File:** `.worktree-config.examples.json` (NEW)
- **Description:** Ready-to-use configurations for popular PHP frameworks
- **Includes:**
  - WordPress with WordPlate (modern WordPress development)
  - WordPress vanilla (standard installation)
  - Laravel framework
  - Symfony framework
  - Generic PHP projects
- **Usage:** Copy desired configuration to `.worktree-config.local.json`
- **Impact:** Easy framework-specific customization without modifying main config

### 📚 Improved

#### Documentation: Updated all references
- **Files:** All README, STACKS_GUIDE, START_HERE, CHEATSHEET files (English and Spanish)
- **Changes:**
  - Replaced WordPress/wp references with PHP
  - Updated examples to show PHP stack usage
  - Added tips about framework-specific configurations
  - Updated roadmap to reflect current capabilities

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
