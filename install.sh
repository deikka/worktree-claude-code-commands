#!/usr/bin/env bash

# Git Worktrees for Claude Code - Installation Script
# This script installs slash commands for managing git worktrees

set -e  # Exit on error

# Parse command line arguments
YES_MODE=false
for arg in "$@"; do
    case $arg in
        -y|--yes)
            YES_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -y, --yes    Non-interactive mode (auto-approve all prompts)"
            echo "  -h, --help   Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Header
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Git Worktrees for Claude Code"
echo "  Installation Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    echo ""
    echo "Please run this script from the root of your git project:"
    echo "  cd /path/to/your/project"
    echo "  ./install.sh"
    echo ""
    exit 1
fi

print_success "Found git repository"

# Get the repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
print_info "Repository root: $REPO_ROOT"
echo ""

# Determine Claude Code config directory
# Claude Code stores custom commands in .claude/ directory
CLAUDE_DIR="$REPO_ROOT/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

# Create directories if they don't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    print_info "Creating .claude directory..."
    mkdir -p "$CLAUDE_DIR"
    print_success "Created $CLAUDE_DIR"
fi

if [ ! -d "$COMMANDS_DIR" ]; then
    print_info "Creating commands directory..."
    mkdir -p "$COMMANDS_DIR"
    print_success "Created $COMMANDS_DIR"
fi

echo ""
print_info "Installing commands..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Commands to install
declare -a COMMANDS=(
    "worktree-start.md"
    "worktree-compare.md"
    "worktree-merge.md"
    "worktree-list.md"
)

# Counter for installed commands
INSTALLED=0
FAILED=0

# Install each command
for cmd in "${COMMANDS[@]}"; do
    SRC_FILE="$SCRIPT_DIR/$cmd"
    DST_FILE="$COMMANDS_DIR/$cmd"

    if [ -f "$SRC_FILE" ]; then
        # Check if file already exists
        if [ -f "$DST_FILE" ]; then
            print_warning "$cmd already exists"
            if [ "$YES_MODE" = true ]; then
                echo "  Auto-approving overwrite (--yes mode)"
                # Copy the file
                cp "$SRC_FILE" "$DST_FILE"
                print_success "Installed $cmd"
                ((INSTALLED++))
            else
                read -p "  Overwrite? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    # Copy the file
                    cp "$SRC_FILE" "$DST_FILE"
                    print_success "Installed $cmd"
                    ((INSTALLED++))
                else
                    print_info "  Skipped $cmd"
                fi
            fi
        else
            # Copy the file (new installation)
            cp "$SRC_FILE" "$DST_FILE"
            print_success "Installed $cmd"
            ((INSTALLED++))
        fi
    else
        print_error "Source file not found: $SRC_FILE"
        ((FAILED++))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_success "Installed: $INSTALLED command(s)"

if [ $FAILED -gt 0 ]; then
    print_error "Failed: $FAILED command(s)"
fi

echo ""

# Create .gitignore entry if needed
GITIGNORE_FILE="$REPO_ROOT/.gitignore"
CLAUDE_ENTRY=".claude/"

if [ -f "$GITIGNORE_FILE" ]; then
    if ! grep -q "^\.claude/" "$GITIGNORE_FILE"; then
        print_info "Adding .claude/ to .gitignore..."
        echo "" >> "$GITIGNORE_FILE"
        echo "# Claude Code custom commands" >> "$GITIGNORE_FILE"
        echo ".claude/" >> "$GITIGNORE_FILE"
        print_success "Added .claude/ to .gitignore"
    else
        print_info ".claude/ already in .gitignore"
    fi
else
    print_warning ".gitignore not found"
    if [ "$YES_MODE" = true ]; then
        REPLY="y"
        echo "Auto-creating .gitignore (--yes mode)"
    else
        read -p "Create .gitignore with .claude/ entry? (y/n) " -n 1 -r
        echo
    fi
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "# Claude Code custom commands" > "$GITIGNORE_FILE"
        echo ".claude/" >> "$GITIGNORE_FILE"
        print_success "Created .gitignore"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Available commands:"
echo "  /worktree-start     - Create new worktree"
echo "  /worktree-compare   - Compare changes before merge"
echo "  /worktree-merge     - Merge and cleanup worktree"
echo "  /worktree-list      - List and manage worktrees"
echo ""
print_info "Commands are available in Claude Code immediately"
echo ""
echo "📚 Documentation:"
echo "  START_HERE.md    - Quick start guide (READ THIS FIRST)"
echo "  CHEATSHEET.md    - Quick reference"
echo "  README.md        - Complete documentation"
echo ""
echo "🚀 Try your first worktree:"
echo "  /worktree-start rails \"Add user authentication\""
echo ""
print_success "Happy parallel development!"
echo ""

# Exit with appropriate code
if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
