#!/usr/bin/env bash
# visual-diff.sh - Visual diff tool detection and integration
# Part of Git Worktrees Management System
# Version: 1.2.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration file
CONFIG_FILE="${WORKTREE_CONFIG_FILE:-.worktree-config.json}"
LOCAL_CONFIG_FILE=".worktree-config.local.json"

# Debug logging
debug() {
  if [ "${VERBOSE:-false}" = "true" ]; then
    echo -e "${BLUE}[DEBUG]${NC} $*" >&2
  fi
}

# Info logging
info() {
  echo -e "${CYAN}ℹ${NC}  $*"
}

# Success logging
success() {
  echo -e "${GREEN}✓${NC}  $*"
}

# Warning logging
warn() {
  echo -e "${YELLOW}⚠${NC}  $*"
}

# Error logging
error() {
  echo -e "${RED}✗${NC}  $*"
}

# Detect available visual diff tools
detect_difftools() {
  debug "Detecting available diff tools..."

  local -a available_tools=()

  # Check each known diff tool
  # macOS tools
  if command -v opendiff &> /dev/null; then
    available_tools+=("opendiff:FileMerge (macOS):opendiff")
    debug "  Found: opendiff (FileMerge)"
  fi

  # Cross-platform tools
  if command -v code &> /dev/null; then
    available_tools+=("vscode:VS Code:code --diff")
    debug "  Found: VS Code"
  fi

  if command -v meld &> /dev/null; then
    available_tools+=("meld:Meld:meld")
    debug "  Found: meld"
  fi

  if command -v kdiff3 &> /dev/null; then
    available_tools+=("kdiff3:KDiff3:kdiff3")
    debug "  Found: kdiff3"
  fi

  if command -v bcomp &> /dev/null; then
    available_tools+=("bcomp:Beyond Compare:bcomp")
    debug "  Found: Beyond Compare"
  fi

  if command -v diffuse &> /dev/null; then
    available_tools+=("diffuse:Diffuse:diffuse")
    debug "  Found: diffuse"
  fi

  if command -v kompare &> /dev/null; then
    available_tools+=("kompare:Kompare:kompare")
    debug "  Found: kompare"
  fi

  # Terminal-based tools (fallback)
  if command -v vimdiff &> /dev/null; then
    available_tools+=("vimdiff:Vimdiff (terminal):vimdiff")
    debug "  Found: vimdiff"
  fi

  # Git's configured difftool
  if git config --get diff.tool &> /dev/null; then
    local git_difftool
    git_difftool=$(git config --get diff.tool)
    available_tools+=("git-difftool:Git difftool ($git_difftool):git difftool")
    debug "  Found: git difftool configured as $git_difftool"
  fi

  # Return the list (newline separated)
  printf '%s\n' "${available_tools[@]}"
}

# Get configured difftool from config
get_configured_tool() {
  local tool=""

  # Check local config first
  if [ -f "$LOCAL_CONFIG_FILE" ] && command -v jq &> /dev/null; then
    tool=$(jq -r '.defaults.visual_diff_tool // ""' "$LOCAL_CONFIG_FILE" 2>/dev/null)
  fi

  # Check main config
  if [ -z "$tool" ] && [ -f "$CONFIG_FILE" ] && command -v jq &> /dev/null; then
    tool=$(jq -r '.defaults.visual_diff_tool // ""' "$CONFIG_FILE" 2>/dev/null)
  fi

  echo "$tool"
}

# Save difftool preference to local config
save_tool_preference() {
  local tool="$1"

  if ! command -v jq &> /dev/null; then
    warn "jq not available, cannot save preference"
    return 1
  fi

  # Create or update local config
  if [ -f "$LOCAL_CONFIG_FILE" ]; then
    # Update existing config
    local tmp_file
    tmp_file=$(mktemp)
    jq ".defaults.visual_diff_tool = \"$tool\"" "$LOCAL_CONFIG_FILE" > "$tmp_file"
    mv "$tmp_file" "$LOCAL_CONFIG_FILE"
  else
    # Create new local config
    cat > "$LOCAL_CONFIG_FILE" <<EOF
{
  "defaults": {
    "visual_diff_tool": "$tool"
  }
}
EOF
  fi

  success "Saved preference: $tool"
}

# Launch visual diff tool
launch_difftool() {
  local tool="$1"
  local file1="$2"
  local file2="$3"
  local label1="${4:-}"
  local label2="${5:-}"

  debug "Launching $tool to compare:"
  debug "  File 1: $file1 ($label1)"
  debug "  File 2: $file2 ($label2)"

  case "$tool" in
    opendiff)
      opendiff "$file1" "$file2" -merge "$file2" 2>/dev/null &
      ;;
    vscode)
      code --diff "$file1" "$file2" --wait 2>/dev/null
      ;;
    meld)
      meld "$file1" "$file2" 2>/dev/null &
      ;;
    kdiff3)
      kdiff3 "$file1" "$file2" 2>/dev/null &
      ;;
    bcomp)
      bcomp "$file1" "$file2" 2>/dev/null &
      ;;
    diffuse)
      diffuse "$file1" "$file2" 2>/dev/null &
      ;;
    kompare)
      kompare "$file1" "$file2" 2>/dev/null &
      ;;
    vimdiff)
      vimdiff "$file1" "$file2"
      ;;
    git-difftool)
      git difftool --no-prompt "$file1" "$file2"
      ;;
    *)
      error "Unknown diff tool: $tool"
      return 1
      ;;
  esac

  return $?
}

# Interactive tool selection
select_difftool() {
  local available_tools
  available_tools=$(detect_difftools)

  if [ -z "$available_tools" ]; then
    error "No visual diff tools found"
    warn "Install one of: meld, kdiff3, VS Code, FileMerge (macOS)"
    return 1
  fi

  # Load interactive prompts if available
  if [ -f "lib/interactive-prompt.sh" ]; then
    source lib/interactive-prompt.sh

    # Build options array
    local -a options=()
    local -a tool_ids=()

    while IFS=':' read -r id name command; do
      options+=("$name")
      tool_ids+=("$id")
    done <<< "$available_tools"

    # Show selection menu
    local selected_index
    selected_index=$(select_option "Select visual diff tool:" "${options[@]}")

    local selected_tool="${tool_ids[$selected_index]}"
    echo "$selected_tool"

    # Ask if they want to save preference
    if confirm "Save as default?" "y"; then
      save_tool_preference "$selected_tool"
    fi
  else
    # Fallback to simple menu
    echo "Available diff tools:"
    local i=1
    local -a tool_ids=()

    while IFS=':' read -r id name command; do
      echo "  $i) $name"
      tool_ids+=("$id")
      ((i++))
    done <<< "$available_tools"

    echo ""
    read -p "Select tool (1-${#tool_ids[@]}): " selection

    if [ "$selection" -ge 1 ] && [ "$selection" -le "${#tool_ids[@]}" ]; then
      local selected_tool="${tool_ids[$((selection-1))]}"
      echo "$selected_tool"

      read -p "Save as default? (y/n): " save_pref
      if [[ "$save_pref" =~ ^[Yy] ]]; then
        save_tool_preference "$selected_tool"
      fi
    else
      error "Invalid selection"
      return 1
    fi
  fi
}

# Get the diff tool to use
get_difftool() {
  # Check for configured tool
  local configured_tool
  configured_tool=$(get_configured_tool)

  if [ -n "$configured_tool" ]; then
    # Verify it's still available
    local available_tools
    available_tools=$(detect_difftools)

    if echo "$available_tools" | grep -q "^${configured_tool}:"; then
      debug "Using configured tool: $configured_tool"
      echo "$configured_tool"
      return 0
    else
      warn "Configured tool '$configured_tool' is not available"
    fi
  fi

  # No configured tool or not available - select one
  select_difftool
}

# Compare two files visually
compare_files() {
  local file1="$1"
  local file2="$2"
  local label1="${3:-File 1}"
  local label2="${4:-File 2}"

  # Get difftool
  local tool
  tool=$(get_difftool)

  if [ $? -ne 0 ] || [ -z "$tool" ]; then
    error "No diff tool selected"
    return 1
  fi

  info "Comparing with $tool..."
  launch_difftool "$tool" "$file1" "$file2" "$label1" "$label2"
}

# Export functions
export -f detect_difftools
export -f get_configured_tool
export -f save_tool_preference
export -f launch_difftool
export -f select_difftool
export -f get_difftool
export -f compare_files

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  # Script is being executed directly
  case "${1:-}" in
    detect)
      detect_difftools
      ;;
    select)
      select_difftool
      ;;
    compare)
      if [ $# -lt 3 ]; then
        error "Usage: $0 compare <file1> <file2> [label1] [label2]"
        exit 1
      fi
      compare_files "$2" "$3" "${4:-}" "${5:-}"
      ;;
    *)
      echo "Usage: $0 {detect|select|compare <file1> <file2>}"
      exit 1
      ;;
  esac
fi
