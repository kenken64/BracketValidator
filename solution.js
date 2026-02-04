/**
 * Validates if brackets in a string are balanced and properly nested.
 *
 * @param {string} input - String containing brackets and other characters
 * @returns {Object} Result object with validation status
 *
 * @example
 * // Success
 * { valid: true }
 *
 * // Failure
 * { valid: false, error: 'Unmatched opening bracket', position: 5 }
 */
function validateBrackets(input) {
    const stack = [];
    const openingBrackets = '([{';
    const closingBrackets = ')]}';
    const bracketPairs = {
        ')': '(',
        ']': '[',
        '}': '{'
    };

    for (let i = 0; i < input.length; i++) {
        const char = input[i];

        if (openingBrackets.includes(char)) {
            stack.push({ bracket: char, position: i });
        } else if (closingBrackets.includes(char)) {
            if (stack.length === 0) {
                return {
                    valid: false,
                    error: 'Unexpected closing bracket',
                    position: i
                };
            }

            const last = stack.pop();
            if (last.bracket !== bracketPairs[char]) {
                return {
                    valid: false,
                    error: 'Mismatched bracket types',
                    position: i
                };
            }
        }
    }

    if (stack.length > 0) {
        return {
            valid: false,
            error: 'Unmatched opening bracket',
            position: stack[stack.length - 1].position
        };
    }

    return { valid: true };
}

module.exports = { validateBrackets };
