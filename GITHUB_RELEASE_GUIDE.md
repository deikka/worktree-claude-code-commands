# GitHub Release Guide

Instructions for publishing this project to GitHub and creating the v1.0.0 release.

---

## Pre-Release Checklist

Before pushing to GitHub, ensure:

- [x] All files committed to git
- [x] Git tag v1.0.0 created
- [x] LICENSE file exists
- [x] README.md is complete
- [x] CONTRIBUTING.md exists
- [x] All badges in README have placeholders for your username
- [ ] LICENSE has your name/organization (currently has placeholder)
- [ ] All README badges updated with your GitHub username
- [ ] Commands verified working in Claude Code (see VERIFICATION_CHECKLIST.md)

---

## Step 1: Create GitHub Repository

1. Go to https://github.com/new

2. Fill in repository details:
   - **Name:** `worktree-claude-code-commands`
   - **Description:** "Git worktree management for Claude Code with AI-powered assistance"
   - **Visibility:** Public
   - **Initialize:** Do NOT initialize with README, .gitignore, or license (we already have these)

3. Click "Create repository"

---

## Step 2: Update Placeholders

Before pushing, update these placeholders in your files:

### In LICENSE
```bash
# Replace placeholder with your info
sed -i '' 's/\[Your Name\/Organization\]/Your Actual Name/g' LICENSE
```

### In README.md
```bash
# Replace 'yourusername' with your actual GitHub username
sed -i '' 's/yourusername/YOUR_GITHUB_USERNAME/g' README.md
sed -i '' 's/yourusername/YOUR_GITHUB_USERNAME/g' RELEASE_NOTES.md
sed -i '' 's/yourusername/YOUR_GITHUB_USERNAME/g' example-project/README.md
```

Or manually edit:
- `README.md` - Update all badge URLs
- `RELEASE_NOTES.md` - Update installation URLs
- `example-project/README.md` - Update clone URLs

---

## Step 3: Push to GitHub

```bash
# Add remote (use your actual repository URL)
git remote add origin https://github.com/YOUR_USERNAME/worktree-claude-code-commands.git

# Or with SSH:
# git remote add origin git@github.com:YOUR_USERNAME/worktree-claude-code-commands.git

# Push main branch
git push -u origin main

# Push tags
git push --tags

# Verify
git remote -v
git branch -vv
```

---

## Step 4: Create GitHub Release

### Option A: Via GitHub Web UI (Recommended)

1. Go to your repository on GitHub
2. Click "Releases" in the right sidebar
3. Click "Create a new release"
4. Fill in the form:

   **Tag version:** `v1.0.0` (select from existing tags)

   **Release title:** `v1.0.0 - First Stable Release`

   **Description:** Copy content from `RELEASE_NOTES.md` or use this summary:

   ```markdown
   ## 🎉 First Stable Release

   Complete git worktree management system for Claude Code with AI-powered assistance.

   ### ✨ Highlights

   - 🤖 Smart worktree creation with AI branch naming
   - 📊 Visual comparison before merge
   - 🧹 Automatic cleanup after merge
   - 🚂 Rails & WordPress support
   - 🌍 English and Spanish documentation
   - ✅ Comprehensive testing and CI/CD

   ### 📦 What's Included

   - 4 slash commands (start, list, compare, merge)
   - Installation script
   - Complete documentation (30+ pages)
   - Example outputs and testing guides
   - Automated tests and CI/CD

   ### 🚀 Quick Start

   ```bash
   bash <(curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/worktree-claude-code-commands/main/install.sh)
   ```

   See [README.md](README.md) for complete documentation.

   ### 📋 Requirements

   - Git 2.17+
   - Bash 4.0+
   - Claude Code (latest)

   ### 🐛 Known Issues

   - Windows support not tested (WSL2 should work)
   - Screenshots are placeholders (real recordings coming soon)

   [Full Release Notes](RELEASE_NOTES.md)
   ```

5. **Set as latest release:** ✅ Check this box
6. Click "Publish release"

### Option B: Via GitHub CLI (gh)

```bash
# Install gh if needed
# macOS: brew install gh
# Linux: See https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Authenticate
gh auth login

# Create release
gh release create v1.0.0 \
  --title "v1.0.0 - First Stable Release" \
  --notes-file RELEASE_NOTES.md \
  --latest

# Verify
gh release view v1.0.0
```

---

## Step 5: Configure Repository Settings

### 5.1 About Section

1. Go to repository settings
2. Edit "About" section:
   - **Description:** "Git worktree management for Claude Code with AI-powered assistance"
   - **Website:** (your project website if any)
   - **Topics:** Add tags:
     - `claude-code`
     - `git-worktree`
     - `git`
     - `ai`
     - `rails`
     - `wordpress`
     - `developer-tools`
     - `productivity`

### 5.2 Enable Features

Settings → General → Features:
- [x] Issues
- [x] Discussions (optional but recommended)
- [ ] Projects (optional)
- [ ] Wiki (not needed, we have docs)

### 5.3 Branch Protection (Optional but Recommended)

Settings → Branches → Add rule:
- **Branch name pattern:** `main`
- **Protection rules:**
  - [x] Require a pull request before merging
  - [x] Require status checks to pass before merging
    - [x] Require branches to be up to date
    - Select: CI checks
  - [x] Require conversation resolution before merging

### 5.4 GitHub Actions

Settings → Actions → General:
- **Actions permissions:** "Allow all actions and reusable workflows"
- **Workflow permissions:** "Read and write permissions"

---

## Step 6: Verify Everything Works

### 6.1 Check CI/CD

1. Go to "Actions" tab
2. Verify workflow runs successfully
3. Fix any issues if CI fails

### 6.2 Test Installation

```bash
# Create test repo
cd /tmp
mkdir test-install
cd test-install
git init
git config user.name "Test"
git config user.email "test@test.com"
echo "test" > README.md
git add . && git commit -m "Initial"

# Test installation from GitHub
bash <(curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/worktree-claude-code-commands/main/install.sh)

# Verify
ls -la .claude/commands/
```

### 6.3 Verify Documentation

- [ ] README badges work (CI badge will work after first action run)
- [ ] All links in README work
- [ ] Installation instructions work
- [ ] Example outputs are visible

---

## Step 7: Announce Release (Optional)

### Social Media

Share on:
- Twitter/X with hashtags: #ClaudeCode #Git #DevTools
- Reddit: r/ClaudeAI, r/git, r/programming
- Dev.to blog post
- Hacker News (Show HN)

### Example Post

```
🎉 Just released v1.0.0 of Git Worktrees for Claude Code!

Manage git worktrees with AI-powered assistance:
- Smart branch naming
- Visual comparisons
- Automatic cleanup
- Rails & WordPress support

Try it: https://github.com/YOUR_USERNAME/worktree-claude-code-commands

#ClaudeCode #Git #DevTools
```

### Community

- Post in Claude Code Discord (if exists)
- Claude AI subreddit
- Dev communities you're part of

---

## Step 8: Monitor and Maintain

### First Week

- [ ] Monitor issue tracker for bug reports
- [ ] Respond to questions in Discussions
- [ ] Watch for CI failures
- [ ] Check if installation works for users

### First Month

- [ ] Address critical bugs with patch release (v1.0.1)
- [ ] Start planning v1.1.0 features
- [ ] Gather user feedback
- [ ] Add real screenshots/recordings

### Ongoing

- [ ] Review PRs promptly
- [ ] Update documentation based on common questions
- [ ] Add more examples
- [ ] Expand platform support

---

## Troubleshooting

### CI Fails After First Push

- Check `.github/workflows/ci.yml` syntax
- Verify all referenced files exist
- Check GitHub Actions logs for details

### Installation Fails for Users

- Ask for error output
- Verify install.sh is executable: `chmod +x install.sh && git add install.sh && git commit --amend`
- Test in clean environment

### Badges Don't Work

- Update URLs with your actual username
- CI badge needs at least one workflow run
- Check shields.io syntax

### Can't Push Tags

```bash
# If tag exists remotely already
git push origin :refs/tags/v1.0.0
git push --tags
```

---

## Next Release Checklist

When preparing v1.1.0 or v1.0.1:

1. Update version in README.md badges
2. Create new tag: `git tag -a v1.1.0 -m "Release v1.1.0"`
3. Update RELEASE_NOTES.md with new version section
4. Push tags: `git push --tags`
5. Create new GitHub release
6. Announce updates

---

## Need Help?

- **GitHub Docs:** https://docs.github.com/en/repositories/releasing-projects-on-github
- **gh CLI Docs:** https://cli.github.com/manual/gh_release_create
- **Shields.io:** https://shields.io for badge customization

---

Good luck with your release! 🚀
