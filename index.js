#!/usr/bin/env node

const readline = require('readline');
const { validateBrackets } = require('./solution');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function printResult(result, input) {
    if (result.valid) {
        console.log('\n✓ Valid: All brackets are balanced and properly nested.\n');
    } else {
        console.log(`\n✗ Invalid: ${result.error}`);
        console.log(`  Position: ${result.position}`);
        console.log(`  Input: ${input}`);
        console.log(`  ${' '.repeat(9 + result.position)}^\n`);
    }
}

function promptUser() {
    rl.question('Enter a string to validate (or "exit" to quit): ', (input) => {
        if (input.toLowerCase() === 'exit') {
            console.log('Goodbye!');
            rl.close();
            return;
        }

        const result = validateBrackets(input);
        printResult(result, input);
        promptUser();
    });
}

// Check if input is provided as command line argument
let args = process.argv.slice(2);

// Handle -- separator (skip it if present)
if (args[0] === '--') {
    args = args.slice(1);
}

// Handle --input flag for explicit input (including empty strings)
const inputFlagIndex = args.indexOf('--input');
if (inputFlagIndex !== -1) {
    const input = args[inputFlagIndex + 1] || '';
    const result = validateBrackets(input);
    printResult(result, input);
    process.exit(result.valid ? 0 : 1);
} else if (args.length > 0) {
    // Non-interactive mode: validate the argument and exit
    const input = args.join(' ');
    const result = validateBrackets(input);
    printResult(result, input);
    process.exit(result.valid ? 0 : 1);
} else {
    // Interactive mode
    console.log('=================================');
    console.log('   Bracket Validator');
    console.log('=================================');
    console.log('Validates (), [], and {} brackets');
    console.log('');
    promptUser();
}
