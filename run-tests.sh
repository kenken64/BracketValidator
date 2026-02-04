#!/bin/bash
# Bracket Validator Test Runner
# Run with: ./run-tests.sh

passed=0
failed=0
delay_sec=3  # Delay between test cases in seconds

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Get terminal width
term_width=$(tput cols 2>/dev/null || echo 80)
if [ "$term_width" -lt 60 ]; then
    term_width=80
fi

center_text() {
    local text="$1"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    if [ $padding -lt 0 ]; then
        padding=0
    fi
    printf "%${padding}s%s\n" "" "$text"
}

center_text_color() {
    local text="$1"
    local color="$2"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    if [ $padding -lt 0 ]; then
        padding=0
    fi
    printf "%${padding}s${color}%s${NC}\n" "" "$text"
}

center_line() {
    local char="${1:--}"
    local length="${2:-50}"
    local line=$(printf "%${length}s" | tr ' ' "$char")
    center_text_color "$line" "$GRAY"
}

test_brackets() {
    local test_input="$1"
    local expect_valid="$2"
    local description="$3"

    echo ""
    center_text_color "Test: $description" "$WHITE"

    if [ -z "$test_input" ]; then
        center_text_color "Input: (empty string)" "$GRAY"
    elif [ ${#test_input} -gt 50 ]; then
        center_text_color "Input: \"${test_input:0:47}...\"" "$CYAN"
    else
        center_text_color "Input: \"$test_input\"" "$CYAN"
    fi

    # Run the validator and capture output
    output=$(node index.js --input "$test_input" 2>&1)
    local exit_code=$?

    center_text_color "Output:" "$GRAY"
    echo "$output" | while IFS= read -r line; do
        trimmed=$(echo "$line" | xargs)
        if [ -n "$trimmed" ]; then
            center_text_color "$trimmed" "$WHITE"
        fi
    done

    local is_valid=false
    if [ $exit_code -eq 0 ]; then
        is_valid=true
    fi

    if [ "$is_valid" = "$expect_valid" ]; then
        center_text_color "[ PASS ]" "$GREEN"
        ((passed++))
    else
        center_text_color "[ FAIL ]" "$RED"
        if [ "$expect_valid" = "true" ]; then
            center_text_color "Expected: valid, Got: invalid" "$YELLOW"
        else
            center_text_color "Expected: invalid, Got: valid" "$YELLOW"
        fi
        ((failed++))
    fi

    center_line "-" 50

    # Delay before next test
    sleep $delay_sec
}

clear
echo ""
center_text_color "=====================================" "$CYAN"
center_text_color "CHALLENGE 1" "$CYAN"
center_text_color "=====================================" "$CYAN"
center_text_color "Running tests with ${delay_sec}s delay..." "$GRAY"

echo ""
echo ""
center_text_color "========== VALID BRACKETS ==========" "$YELLOW"
test_brackets "" "true" "Empty string"
test_brackets "()" "true" "Simple parentheses"
test_brackets "[]" "true" "Simple square brackets"
test_brackets "{}" "true" "Simple curly braces"
test_brackets "([{}])" "true" "Nested brackets"
test_brackets "()[]{}" "true" "Sequential brackets"
test_brackets "{[()]}[]" "true" "Mixed nested and sequential"
test_brackets "function test() { return [1, 2]; }" "true" "Code with brackets"

echo ""
echo ""
center_text_color "========== INVALID BRACKETS ==========" "$YELLOW"
test_brackets "(" "false" "Unclosed opening bracket"
test_brackets ")" "false" "Extra closing bracket"
test_brackets "(]" "false" "Mismatched bracket types"
test_brackets "([)]" "false" "Wrong closing order"
test_brackets "({)}" "false" "Unclosed bracket in middle"
test_brackets "[[[" "false" "Multiple unclosed brackets"
test_brackets "abc(def]ghi" "false" "Mismatch with other chars"

echo ""
echo ""
center_text_color "========== EDGE CASES ==========" "$YELLOW"
test_brackets "hello world" "true" "String with no brackets"
test_brackets "((((((((()))))))))" "true" "Deeply nested brackets"
# Generate 1000 pairs of ()
long_sequence=$(printf '()%.0s' {1..1000})
test_brackets "$long_sequence" "true" "Long valid sequence (1000 pairs)"

echo ""
echo ""
MAGENTA='\033[0;35m'
center_text_color "======== ADDITIONAL TEST CASES ========" "$MAGENTA"
test_brackets "[(])" "false" "Complex nested structure"
test_brackets "({[}]" "false" "Nested mismatch position"
test_brackets ")(" "false" "Balanced reverse brackets"

echo ""
echo ""
center_text_color "=====================================" "$CYAN"
center_text_color "FINAL RESULTS" "$CYAN"
center_text_color "=====================================" "$CYAN"
echo ""
center_text_color "Passed: $passed" "$GREEN"
if [ $failed -gt 0 ]; then
    center_text_color "Failed: $failed" "$RED"
else
    center_text_color "Failed: $failed" "$GREEN"
fi
center_text_color "Total:  $((passed + failed))" "$WHITE"
echo ""
center_text_color "=====================================" "$CYAN"
echo ""

exit $failed
