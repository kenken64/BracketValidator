# Bracket Validator Test Runner
# Run with: .\run-tests.ps1

$passed = 0
$failed = 0
$delayMs = 3000  # Delay between test cases in milliseconds

# Get terminal width
$termWidth = $Host.UI.RawUI.WindowSize.Width
if ($termWidth -lt 60) { $termWidth = 80 }

function Center-Text {
    param([string]$Text, [int]$Width = $termWidth)
    $padding = [math]::Max(0, [math]::Floor(($Width - $Text.Length) / 2))
    return (" " * $padding) + $Text
}

function Write-Centered {
    param(
        [string]$Text,
        [string]$ForegroundColor = "White",
        [switch]$NoNewline
    )
    $centered = Center-Text -Text $Text
    if ($NoNewline) {
        Write-Host $centered -ForegroundColor $ForegroundColor -NoNewline
    } else {
        Write-Host $centered -ForegroundColor $ForegroundColor
    }
}

function Write-CenteredLine {
    param([string]$Char = "-", [int]$Length = 50)
    $line = $Char * $Length
    Write-Centered -Text $line -ForegroundColor DarkGray
}

function Test-Brackets {
    param(
        [string]$TestInput,
        [bool]$ExpectValid,
        [string]$Description
    )

    Write-Host ""
    Write-Centered -Text "Test: $Description" -ForegroundColor White

    if ($TestInput -eq "") {
        Write-Centered -Text "Input: (empty string)" -ForegroundColor DarkGray
    } elseif ($TestInput.Length -gt 50) {
        Write-Centered -Text "Input: `"$($TestInput.Substring(0, 47))...`"" -ForegroundColor Cyan
    } else {
        Write-Centered -Text "Input: `"$TestInput`"" -ForegroundColor Cyan
    }

    # Run the validator and capture output
    $output = & node index.js "--input" "$TestInput" 2>&1
    $exitCode = $LASTEXITCODE

    Write-Centered -Text "Output:" -ForegroundColor Gray
    foreach ($line in $output) {
        $trimmed = $line.ToString().Trim()
        if ($trimmed -ne "") {
            Write-Centered -Text $trimmed -ForegroundColor White
        }
    }

    $isValid = ($exitCode -eq 0)
    $testPassed = ($isValid -eq $ExpectValid)

    if ($testPassed) {
        Write-Centered -Text "[ PASS ]" -ForegroundColor Green
        $script:passed++
    } else {
        Write-Centered -Text "[ FAIL ]" -ForegroundColor Red
        $expected = if ($ExpectValid) { "valid" } else { "invalid" }
        $got = if ($isValid) { "valid" } else { "invalid" }
        Write-Centered -Text "Expected: $expected, Got: $got" -ForegroundColor Yellow
        $script:failed++
    }

    Write-CenteredLine

    # Delay before next test
    Start-Sleep -Milliseconds $delayMs
}

Clear-Host
Write-Host ""
Write-Centered -Text "=====================================" -ForegroundColor Cyan
Write-Centered -Text "CHALLENGE 1" -ForegroundColor Cyan
Write-Centered -Text "=====================================" -ForegroundColor Cyan
Write-Centered -Text "Running tests with ${delayMs}ms delay..." -ForegroundColor DarkGray

Write-Host ""
Write-Host ""
Write-Centered -Text "========== VALID BRACKETS ==========" -ForegroundColor Yellow
Test-Brackets -TestInput "" -ExpectValid $true -Description "Empty string"
Test-Brackets -TestInput "()" -ExpectValid $true -Description "Simple parentheses"
Test-Brackets -TestInput "[]" -ExpectValid $true -Description "Simple square brackets"
Test-Brackets -TestInput "{}" -ExpectValid $true -Description "Simple curly braces"
Test-Brackets -TestInput "([{}])" -ExpectValid $true -Description "Nested brackets"
Test-Brackets -TestInput "()[]{}" -ExpectValid $true -Description "Sequential brackets"
Test-Brackets -TestInput "{[()]}[]" -ExpectValid $true -Description "Mixed nested and sequential"
Test-Brackets -TestInput "function test() { return [1, 2]; }" -ExpectValid $true -Description "Code with brackets"

Write-Host ""
Write-Host ""
Write-Centered -Text "========== INVALID BRACKETS ==========" -ForegroundColor Yellow
Test-Brackets -TestInput "(" -ExpectValid $false -Description "Unclosed opening bracket"
Test-Brackets -TestInput ")" -ExpectValid $false -Description "Extra closing bracket"
Test-Brackets -TestInput "(]" -ExpectValid $false -Description "Mismatched bracket types"
Test-Brackets -TestInput "([)]" -ExpectValid $false -Description "Wrong closing order"
Test-Brackets -TestInput "({)}" -ExpectValid $false -Description "Unclosed bracket in middle"
Test-Brackets -TestInput "[[[" -ExpectValid $false -Description "Multiple unclosed brackets"
Test-Brackets -TestInput "abc(def]ghi" -ExpectValid $false -Description "Mismatch with other chars"

Write-Host ""
Write-Host ""
Write-Centered -Text "========== EDGE CASES ==========" -ForegroundColor Yellow
Test-Brackets -TestInput "hello world" -ExpectValid $true -Description "String with no brackets"
Test-Brackets -TestInput "((((((((()))))))))" -ExpectValid $true -Description "Deeply nested brackets"
Test-Brackets -TestInput ("()" * 1000) -ExpectValid $true -Description "Long valid sequence (1000 pairs)"

Write-Host ""
Write-Host ""
Write-Centered -Text "======== ADDITIONAL TEST CASES ========" -ForegroundColor Magenta
Test-Brackets -TestInput "[(])" -ExpectValid $false -Description "Complex nested structure"
Test-Brackets -TestInput "({[}]" -ExpectValid $false -Description "Nested mismatch position"
Test-Brackets -TestInput ")(" -ExpectValid $false -Description "Balanced reverse brackets"

Write-Host ""
Write-Host ""
Write-Centered -Text "=====================================" -ForegroundColor Cyan
Write-Centered -Text "FINAL RESULTS" -ForegroundColor Cyan
Write-Centered -Text "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Centered -Text "Passed: $passed" -ForegroundColor Green
Write-Centered -Text "Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })
Write-Centered -Text "Total:  $($passed + $failed)" -ForegroundColor White
Write-Host ""
Write-Centered -Text "=====================================" -ForegroundColor Cyan
Write-Host ""

exit $failed
