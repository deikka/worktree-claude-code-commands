#!/usr/bin/env bash
# detect-stack.sh - Automatic stack detection based on project files
# Part of Git Worktrees Management System
# Version: 1.2.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file path
CONFIG_FILE="${WORKTREE_CONFIG_FILE:-.worktree-config.json}"

# Verbose mode (set via VERBOSE environment variable)
VERBOSE="${VERBOSE:-false}"

# Debug logging
debug() {
  if [ "$VERBOSE" = "true" ]; then
    echo -e "${BLUE}[DEBUG]${NC} $*" >&2
  fi
}

# Error logging
error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Warning logging
warn() {
  echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

# Success logging
success() {
  echo -e "${GREEN}[OK]${NC} $*" >&2
}

# Check if a file exists
file_exists() {
  local path="$1"
  [ -f "$path" ]
}

# Check if a directory exists
dir_exists() {
  local path="$1"
  [ -d "$path" ]
}

# Check if jq is available
check_jq() {
  if ! command -v jq &> /dev/null; then
    error "jq is required for automatic stack detection"
    warn "Install jq with: brew install jq (macOS) or apt-get install jq (Linux)"
    return 1
  fi
  return 0
}

# Validate config file exists
check_config() {
  if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found: $CONFIG_FILE"
    warn "Run this from repository root or set WORKTREE_CONFIG_FILE"
    return 1
  fi
  return 0
}

# Check if a stack matches based on its detection patterns
check_stack_match() {
  local stack_name="$1"
  local config_file="$2"

  debug "Checking stack: $stack_name"

  # Get detection patterns for this stack
  local patterns
  patterns=$(jq -r ".stacks[\"$stack_name\"].detection_patterns" "$config_file")

  if [ "$patterns" = "null" ] || [ "$patterns" = "[]" ]; then
    debug "  No detection patterns defined"
    return 1
  fi

  # Track required patterns found
  local required_found=0
  local required_total=0
  local optional_found=0

  # Check each pattern
  local pattern_count
  pattern_count=$(echo "$patterns" | jq 'length')

  for ((i=0; i<pattern_count; i++)); do
    local type
    local path
    local required

    type=$(echo "$patterns" | jq -r ".[$i].type")
    path=$(echo "$patterns" | jq -r ".[$i].path")
    required=$(echo "$patterns" | jq -r ".[$i].required // false")

    debug "  Pattern $((i+1)): type=$type, path=$path, required=$required"

    local found=false

    case "$type" in
      file)
        if file_exists "$path"; then
          found=true
          debug "    ✓ File found: $path"
        else
          debug "    ✗ File not found: $path"
        fi
        ;;
      directory)
        if dir_exists "$path"; then
          found=true
          debug "    ✓ Directory found: $path"
        else
          debug "    ✗ Directory not found: $path"
        fi
        ;;
      *)
        warn "Unknown pattern type: $type"
        ;;
    esac

    if [ "$required" = "true" ]; then
      required_total=$((required_total + 1))
      if [ "$found" = "true" ]; then
        required_found=$((required_found + 1))
      fi
    else
      if [ "$found" = "true" ]; then
        optional_found=$((optional_found + 1))
      fi
    fi
  done

  debug "  Required: $required_found/$required_total, Optional: $optional_found"

  # For stacks with no required patterns (like Python), need at least one optional
  if [ "$required_total" -eq 0 ]; then
    if [ "$optional_found" -gt 0 ]; then
      debug "  ✓ Match (at least one optional pattern found)"
      return 0
    else
      debug "  ✗ No match (no patterns found)"
      return 1
    fi
  fi

  # Check if all required patterns are satisfied
  if [ "$required_found" -eq "$required_total" ]; then
    debug "  ✓ Match (all required patterns found)"
    return 0
  else
    debug "  ✗ No match (missing required patterns)"
    return 1
  fi
}

# Detect the project stack
detect_stack() {
  local config_file="${1:-$CONFIG_FILE}"

  debug "Starting stack detection..."
  debug "Config file: $config_file"
  debug "Current directory: $(pwd)"

  # Prerequisites
  check_jq || return 1
  check_config || return 1

  # Get all available stacks
  local stacks
  stacks=$(jq -r '.stacks | keys[]' "$config_file")

  debug "Available stacks: $(echo "$stacks" | tr '\n' ' ')"

  # Track matches with their priorities (bash 3.x compatible approach)
  local matched_stacks=""
  local matched_priorities=""

  # Check each stack
  while IFS= read -r stack; do
    if check_stack_match "$stack" "$config_file"; then
      # Get priority for this stack
      local priority
      priority=$(jq -r ".stacks[\"$stack\"].detection_priority // 50" "$config_file")

      # Store match
      if [ -z "$matched_stacks" ]; then
        matched_stacks="$stack"
        matched_priorities="$priority"
      else
        matched_stacks="$matched_stacks|$stack"
        matched_priorities="$matched_priorities|$priority"
      fi

      debug "Stack '$stack' matched with priority $priority"
    fi
  done <<< "$stacks"

  # If no matches, return generic
  if [ -z "$matched_stacks" ]; then
    debug "No stack matched, defaulting to 'generic'"
    echo "generic"
    return 0
  fi

  # Find the stack with highest priority
  local best_stack=""
  local best_priority=-1

  # Convert to arrays
  IFS='|' read -ra stack_array <<< "$matched_stacks"
  IFS='|' read -ra priority_array <<< "$matched_priorities"

  for i in "${!stack_array[@]}"; do
    local stack="${stack_array[$i]}"
    local priority="${priority_array[$i]}"

    if [ "$priority" -gt "$best_priority" ]; then
      best_priority="$priority"
      best_stack="$stack"
    fi
  done

  debug "Best match: $best_stack (priority: $best_priority)"
  echo "$best_stack"
  return 0
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  # Script is being executed directly
  detected_stack=$(detect_stack "$@")
  exit_code=$?

  if [ $exit_code -eq 0 ]; then
    success "Detected stack: $detected_stack"
    echo "$detected_stack"
  fi

  exit $exit_code
fi
