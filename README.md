# Challenge 1: Bracket Validator

A Node.js terminal application that validates whether brackets in a string are properly balanced and nested.

## Features

- Validates three bracket types: `()`, `[]`, `{}`
- Ignores non-bracket characters
- Reports error position for invalid input
- Interactive and command-line modes
- Comprehensive test suite with 22 test cases
- Visual test runner with centered output

## Installation

```bash
# Clone the repository
git clone https://github.com/kenken64/BracketValidator.git
cd BracketValidator

# Install dependencies
npm install
```

## Usage

### Interactive Mode

```bash
npm start
```

This launches an interactive prompt where you can enter strings to validate.

### Command-Line Mode

```bash
node index.js "your string here"
```

Examples:
```bash
# Valid brackets
node index.js "()"
node index.js "{[()]}"
node index.js "function test() { return [1, 2]; }"

# Invalid brackets
node index.js "(]"
node index.js "([)]"
```

### Exit Codes

- `0` - Valid brackets
- `1` - Invalid brackets

## Running Tests

### Mocha Test Suite

```bash
npm test
```

### Visual Test Runner

**PowerShell (Windows):**
```powershell
.\run-tests.ps1
```

**Bash (Linux/macOS):**
```bash
chmod +x run-tests.sh
./run-tests.sh
```

The visual test runner displays:
- Centered output
- Color-coded results
- 3-second delay between test cases
- Input and output for each test

## Test Cases

| Category | Count | Description |
|----------|-------|-------------|
| Valid Brackets | 9 | Empty string, simple pairs, nested, sequential, code snippets |
| Invalid Brackets | 7 | Unclosed, extra closing, mismatched, wrong order |
| Edge Cases | 3 | No brackets, deeply nested, long sequences |
| Additional Test Cases | 3 | Complex validation scenarios |
| **Total** | **22** | |

## Project Structure

```
BracketValidator/
├── solution.js           # Core validation logic
├── solution.test.js      # Mocha test suite (22 tests)
├── index.js              # CLI application
├── package.json          # Project configuration
├── run-tests.ps1         # PowerShell test runner
├── run-tests.sh          # Bash test runner
├── EVALUATION.md         # Completed evaluation report
├── EVALUATION_TEMPLATE.md # Blank evaluation template
└── README.md             # This file
```

## API

### `validateBrackets(input)`

Validates if brackets in a string are balanced and properly nested.

**Parameters:**
- `input` (string) - String containing brackets and other characters

**Returns:**
- Success: `{ valid: true }`
- Failure: `{ valid: false, error: string, position: number }`

**Example:**
```javascript
const { validateBrackets } = require('./solution');

// Valid
validateBrackets('([{}])');
// => { valid: true }

// Invalid
validateBrackets('(]');
// => { valid: false, error: 'Mismatched bracket types', position: 1 }
```

## Algorithm

The validator uses a stack-based approach:

1. Iterate through each character in the input
2. Push opening brackets onto the stack with their position
3. For closing brackets, check if they match the top of the stack
4. If mismatch or empty stack, return error with position
5. After iteration, check for unclosed brackets remaining in stack

**Time Complexity:** O(n)
**Space Complexity:** O(n)

## Evaluation

Two evaluation documents are included:

- `EVALUATION.md` - Completed evaluation with grades
- `EVALUATION_TEMPLATE.md` - Blank template for manual evaluation

## License

ISC
