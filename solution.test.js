const assert = require('assert');
const { validateBrackets } = require('./solution');

describe('Bracket Validator', () => {

    describe('Valid Brackets', () => {

        it('should validate empty string', () => {
            const result = validateBrackets('');
            assert.strictEqual(result.valid, true);
        });

        it('should validate simple parentheses', () => {
            const result = validateBrackets('()');
            assert.strictEqual(result.valid, true);
        });

        it('should validate simple square brackets', () => {
            const result = validateBrackets('[]');
            assert.strictEqual(result.valid, true);
        });

        it('should validate simple curly braces', () => {
            const result = validateBrackets('{}');
            assert.strictEqual(result.valid, true);
        });

        it('should validate nested brackets', () => {
            const result = validateBrackets('([{}])');
            assert.strictEqual(result.valid, true);
        });

        it('should validate sequential brackets', () => {
            const result = validateBrackets('()[]{}');
            assert.strictEqual(result.valid, true);
        });

        it('should validate mixed nested and sequential', () => {
            const result = validateBrackets('{[()]}[]');
            assert.strictEqual(result.valid, true);
        });

        it('should ignore non-bracket characters', () => {
            const result = validateBrackets('function test() { return [1, 2]; }');
            assert.strictEqual(result.valid, true);
        });

        it('should validate real code snippet', () => {
            const code = 'const arr = [1, 2, 3].map((x) => { return x * 2; });';
            const result = validateBrackets(code);
            assert.strictEqual(result.valid, true);
        });
    });

    describe('Invalid Brackets', () => {

        it('should detect unclosed opening bracket', () => {
            const result = validateBrackets('(');
            assert.strictEqual(result.valid, false);
        });

        it('should detect extra closing bracket', () => {
            const result = validateBrackets(')');
            assert.strictEqual(result.valid, false);
        });

        it('should detect mismatched bracket types', () => {
            const result = validateBrackets('(]');
            assert.strictEqual(result.valid, false);
        });

        it('should detect wrong closing order', () => {
            const result = validateBrackets('([)]');
            assert.strictEqual(result.valid, false);
        });

        it('should detect unclosed bracket in middle', () => {
            const result = validateBrackets('({)}');
            assert.strictEqual(result.valid, false);
        });

        it('should detect multiple unclosed brackets', () => {
            const result = validateBrackets('[[[');
            assert.strictEqual(result.valid, false);
        });

        it('should report error position', () => {
            const result = validateBrackets('abc(def]ghi');
            assert.strictEqual(result.valid, false);
            assert.strictEqual(result.position, 7); // position of ']'
        });
    });

    describe('Edge Cases', () => {

        it('should handle string with no brackets', () => {
            const result = validateBrackets('hello world');
            assert.strictEqual(result.valid, true);
        });

        it('should handle deeply nested brackets', () => {
            const result = validateBrackets('((((((((()))))))))');
            assert.strictEqual(result.valid, true);
        });

        it('should handle long valid sequence', () => {
            const result = validateBrackets('()'.repeat(1000));
            assert.strictEqual(result.valid, true);
        });
    });

    describe('Additional Test Cases', () => {

        it('should validate complex nested structure', () => {
            const result = validateBrackets('[(])');
            assert.strictEqual(result.valid, false);
        });

        it('should report correct error position for nested mismatch', () => {
            const result = validateBrackets('({[}]');
            assert.strictEqual(result.valid, false);
            assert.strictEqual(result.position, 3);
        });

        it('should validate balanced reverse brackets', () => {
            const result = validateBrackets(')(');
            assert.strictEqual(result.valid, false);
        });

    });
});
