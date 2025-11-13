#!/usr/bin/env bash
# Test script for install.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
print_test() {
    echo -e "${YELLOW}▶ TEST:${NC} $1"
}

print_pass() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
    ((TESTS_PASSED++))
}

print_fail() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    ((TESTS_FAILED++))
}

run_test() {
    ((TESTS_RUN++))
}

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SCRIPT="$PROJECT_ROOT/install.sh"

echo "============================================"
echo "Testing install.sh"
echo "============================================"
echo ""

# Test 1: Check install.sh exists
print_test "install.sh exists"
run_test
if [ -f "$INSTALL_SCRIPT" ]; then
    print_pass "install.sh found at $INSTALL_SCRIPT"
else
    print_fail "install.sh not found"
    exit 1
fi

# Test 2: Check bash syntax
print_test "Bash syntax is valid"
run_test
if bash -n "$INSTALL_SCRIPT"; then
    print_pass "No syntax errors"
else
    print_fail "Syntax errors found"
    exit 1
fi

# Test 3: Check required command files exist
print_test "All required command files exist"
run_test
REQUIRED_FILES=(
    "worktree-start.md"
    "worktree-list.md"
    "worktree-compare.md"
    "worktree-merge.md"
)

ALL_EXIST=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$PROJECT_ROOT/$file" ]; then
        print_fail "Missing required file: $file"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = true ]; then
    print_pass "All required command files exist"
else
    print_fail "Some required files are missing"
fi

# Test 4: Create temporary test repository
print_test "Installation in test repository"
run_test

TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize git repo
git init --initial-branch=main > /dev/null 2>&1
git config user.name "Test User"
git config user.email "test@example.com"
echo "# Test" > README.md
git add .
git commit -m "Initial commit" > /dev/null 2>&1

# Run install script with auto-confirm
if echo "y" | bash "$INSTALL_SCRIPT" > /dev/null 2>&1; then
    print_pass "Installation completed successfully"
else
    print_fail "Installation failed"
    cd "$PROJECT_ROOT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Test 5: Verify .claude/commands directory created
print_test ".claude/commands directory exists"
run_test
if [ -d ".claude/commands" ]; then
    print_pass ".claude/commands directory created"
else
    print_fail ".claude/commands directory not created"
fi

# Test 6: Verify all commands copied
print_test "All commands copied correctly"
run_test
ALL_COPIED=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f ".claude/commands/$file" ]; then
        print_fail "Command not copied: $file"
        ALL_COPIED=false
    fi
done

if [ "$ALL_COPIED" = true ]; then
    print_pass "All commands copied successfully"
else
    print_fail "Some commands were not copied"
fi

# Test 7: Verify .gitignore updated
print_test ".gitignore includes .claude/"
run_test
if grep -q "^\.claude/$" .gitignore 2>/dev/null; then
    print_pass ".gitignore updated correctly"
else
    print_fail ".gitignore not updated"
fi

# Test 8: Verify YAML frontmatter in commands
print_test "Command files have valid YAML frontmatter"
run_test
ALL_VALID=true
for file in "${REQUIRED_FILES[@]}"; do
    if ! head -n 5 ".claude/commands/$file" | grep -q "^---$" 2>/dev/null; then
        print_fail "Invalid frontmatter in $file"
        ALL_VALID=false
    fi
    if ! head -n 5 ".claude/commands/$file" | grep -q "description:" 2>/dev/null; then
        print_fail "Missing description in $file"
        ALL_VALID=false
    fi
done

if [ "$ALL_VALID" = true ]; then
    print_pass "All commands have valid YAML frontmatter"
else
    print_fail "Some commands have invalid frontmatter"
fi

# Test 9: Verify file permissions
print_test "install.sh has execute permissions"
run_test
if [ -x "$INSTALL_SCRIPT" ]; then
    print_pass "install.sh is executable"
else
    # This is not critical, just a recommendation
    echo -e "${YELLOW}⚠ WARNING:${NC} install.sh is not executable (not critical)"
fi

# Test 10: Test re-installation (overwrite scenario)
print_test "Re-installation with overwrite"
run_test

# Modify a command file
echo "# Modified" >> .claude/commands/worktree-start.md

# Run install again with confirm
if echo "y" | bash "$INSTALL_SCRIPT" > /dev/null 2>&1; then
    # Check if file was overwritten
    if ! grep -q "# Modified" .claude/commands/worktree-start.md 2>/dev/null; then
        print_pass "Re-installation with overwrite works"
    else
        print_fail "File was not overwritten"
    fi
else
    print_fail "Re-installation failed"
fi

# Cleanup
cd "$PROJECT_ROOT"
rm -rf "$TEST_DIR"

# Summary
echo ""
echo "============================================"
echo "Test Summary"
echo "============================================"
echo -e "Tests run:    ${TESTS_RUN}"
echo -e "${GREEN}Tests passed: ${TESTS_PASSED}${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}Tests failed: ${TESTS_FAILED}${NC}"
else
    echo -e "Tests failed: ${TESTS_FAILED}"
fi
echo "============================================"

if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}✅ ALL TESTS PASSED${NC}"
    exit 0
fi
