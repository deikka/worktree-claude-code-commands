#!/usr/bin/env bash
# interactive-prompt.sh - Interactive prompts for worktree commands
# Part of Git Worktrees Management System
# Version: 1.2.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Display a menu and get user selection
# Usage: select_option "Question?" "option1" "option2" "option3"
# Returns: Selected option (0-indexed)
select_option() {
  local prompt="$1"
  shift
  local options=("$@")
  local selected=0
  local last_index=$((${#options[@]} - 1))

  # Hide cursor
  tput civis

  while true; do
    # Clear previous menu
    if [ $selected -gt 0 ]; then
      tput cuu $((${#options[@]} + 1))
    fi

    # Print question
    echo -e "${BOLD}${CYAN}${prompt}${NC}"

    # Print options
    for i in "${!options[@]}"; do
      if [ $i -eq $selected ]; then
        echo -e "${GREEN}▶ ${options[$i]}${NC}"
      else
        echo -e "  ${options[$i]}"
      fi
    done

    # Read arrow keys
    read -rsn1 key

    case "$key" in
      $'\x1b')  # ESC sequence
        read -rsn2 -t 0.1 key
        case "$key" in
          '[A')  # Up arrow
            if [ $selected -gt 0 ]; then
              selected=$((selected - 1))
            fi
            ;;
          '[B')  # Down arrow
            if [ $selected -lt $last_index ]; then
              selected=$((selected + 1))
            fi
            ;;
        esac
        ;;
      '')  # Enter key
        break
        ;;
      'q'|'Q')  # Quit
        tput cnorm
        echo -e "\n${RED}Cancelled${NC}"
        exit 1
        ;;
    esac
  done

  # Show cursor again
  tput cnorm

  # Return selected index
  echo "$selected"
}

# Simple yes/no prompt
# Usage: confirm "Continue?"
# Returns: 0 for yes, 1 for no
confirm() {
  local prompt="$1"
  local default="${2:-y}"  # Default to yes

  if [ "$default" = "y" ]; then
    local options="[Y/n]"
  else
    local options="[y/N]"
  fi

  while true; do
    echo -n -e "${BOLD}${CYAN}${prompt}${NC} ${options}: "
    read -r response

    # Use default if empty
    if [ -z "$response" ]; then
      response="$default"
    fi

    case "$response" in
      [Yy]*)
        return 0
        ;;
      [Nn]*)
        return 1
        ;;
      *)
        echo -e "${YELLOW}Please answer y or n${NC}"
        ;;
    esac
  done
}

# Text input prompt
# Usage: prompt_input "Enter branch name:" "default-value"
# Returns: User input or default
prompt_input() {
  local prompt="$1"
  local default="${2:-}"

  if [ -n "$default" ]; then
    echo -n -e "${BOLD}${CYAN}${prompt}${NC} [${default}]: "
  else
    echo -n -e "${BOLD}${CYAN}${prompt}${NC}: "
  fi

  read -r response

  # Use default if empty
  if [ -z "$response" ] && [ -n "$default" ]; then
    echo "$default"
  else
    echo "$response"
  fi
}

# Display info message
info() {
  echo -e "${BLUE}ℹ${NC}  $*"
}

# Display success message
success() {
  echo -e "${GREEN}✓${NC}  $*"
}

# Display warning message
warn() {
  echo -e "${YELLOW}⚠${NC}  $*"
}

# Display error message
error() {
  echo -e "${RED}✗${NC}  $*"
}

# Display a boxed message
box() {
  local message="$1"
  local width=60
  local border="$(printf '─%.0s' $(seq 1 $width))"

  echo -e "${CYAN}┌${border}┐${NC}"
  echo -e "${CYAN}│${NC} ${BOLD}${message}${NC}"
  echo -e "${CYAN}└${border}┘${NC}"
}

# Multi-select menu (checkbox style)
# Usage: multi_select "Select options:" "option1" "option2" "option3"
# Returns: Space-separated indices of selected options
multi_select() {
  local prompt="$1"
  shift
  local options=("$@")
  local selected=0
  local last_index=$((${#options[@]} - 1))
  local -a checked=()

  # Initialize all as unchecked
  for i in "${!options[@]}"; do
    checked[$i]=0
  done

  # Hide cursor
  tput civis

  echo -e "${BOLD}${CYAN}${prompt}${NC}"
  echo -e "${CYAN}(Use ↑↓ to navigate, Space to select, Enter to confirm)${NC}"
  echo ""

  while true; do
    # Clear previous menu
    if [ $selected -gt 0 ]; then
      tput cuu $((${#options[@]}))
    fi

    # Print options
    for i in "${!options[@]}"; do
      local checkbox="☐"
      if [ ${checked[$i]} -eq 1 ]; then
        checkbox="${GREEN}☑${NC}"
      fi

      if [ $i -eq $selected ]; then
        echo -e "${GREEN}▶${NC} $checkbox ${options[$i]}"
      else
        echo -e "  $checkbox ${options[$i]}"
      fi
    done

    # Read arrow keys
    read -rsn1 key

    case "$key" in
      $'\x1b')  # ESC sequence
        read -rsn2 -t 0.1 key
        case "$key" in
          '[A')  # Up arrow
            if [ $selected -gt 0 ]; then
              selected=$((selected - 1))
            fi
            ;;
          '[B')  # Down arrow
            if [ $selected -lt $last_index ]; then
              selected=$((selected + 1))
            fi
            ;;
        esac
        ;;
      ' ')  # Space - toggle selection
        if [ ${checked[$selected]} -eq 0 ]; then
          checked[$selected]=1
        else
          checked[$selected]=0
        fi
        ;;
      '')  # Enter key
        break
        ;;
      'q'|'Q')  # Quit
        tput cnorm
        echo -e "\n${RED}Cancelled${NC}"
        exit 1
        ;;
    esac
  done

  # Show cursor again
  tput cnorm

  # Return indices of checked items
  local result=""
  for i in "${!checked[@]}"; do
    if [ ${checked[$i]} -eq 1 ]; then
      if [ -z "$result" ]; then
        result="$i"
      else
        result="$result $i"
      fi
    fi
  done

  echo "$result"
}

# Export functions for use in other scripts
export -f select_option
export -f confirm
export -f prompt_input
export -f info
export -f success
export -f warn
export -f error
export -f box
export -f multi_select
