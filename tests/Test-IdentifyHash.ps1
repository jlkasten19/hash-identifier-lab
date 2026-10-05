# Run the actual script against independently chosen positive and negative inputs.
$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot '../Identify-Hash.ps1'

$cases = @(
    @{ Name = 'Known lowercase MD5 example'; Value = '5d41402abc4b2a76b9719d911017c592'; Expected = 'Possible MD5 format.' },
    @{ Name = 'Uppercase hexadecimal'; Value = '5D41402ABC4B2A76B9719D911017C592'; Expected = 'Possible MD5 format.' },
    @{ Name = 'Mixed case hexadecimal'; Value = '5d41402AbC4b2A76b9719D911017c592'; Expected = 'Possible MD5 format.' },
    @{ Name = 'All digits still match format'; Value = '01234567890123456789012345678901'; Expected = 'Possible MD5 format.' },
    @{ Name = 'All hexadecimal letters'; Value = 'abcdefabcdefabcdefabcdefabcdefab'; Expected = 'Possible MD5 format.' },
    @{ Name = 'Other algorithm can share the format'; Value = '8846f7eaee8fb117ad06bdd830b7586c'; Expected = 'Possible MD5 format.' },
    @{ Name = 'Non-hex g with the same length'; Value = 'gd41402abc4b2a76b9719d911017c592'; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Empty input'; Value = ''; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Plain text'; Value = 'hello'; Expected = 'Does not match MD5 format.' },
    @{ Name = '31 hexadecimal characters'; Value = 'd41402abc4b2a76b9719d911017c592'; Expected = 'Does not match MD5 format.' },
    @{ Name = '33 hexadecimal characters'; Value = '05d41402abc4b2a76b9719d911017c592'; Expected = 'Does not match MD5 format.' },
    @{ Name = '40 hexadecimal characters'; Value = 'aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d'; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Leading space'; Value = ' 5d41402abc4b2a76b9719d911017c592'; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Trailing space'; Value = '5d41402abc4b2a76b9719d911017c592 '; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Internal space'; Value = '5d41402abc4b2a76 9719d911017c592'; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Trailing newline after 31 hex characters'; Value = "d41402abc4b2a76b9719d911017c592`n"; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Trailing newline after 32 hex characters'; Value = "5d41402abc4b2a76b9719d911017c592`n"; Expected = 'Does not match MD5 format.' },
    @{ Name = 'Punctuation at the same length'; Value = '!d41402abc4b2a76b9719d911017c592'; Expected = 'Does not match MD5 format.' }
)

$failures = 0
foreach ($case in $cases) {
    $actual = @(& $scriptPath -Hash $case.Value)
    if (($actual.Count -eq 1) -and ($actual[0] -ceq $case.Expected)) {
        Write-Output "PASS: $($case.Name)"
    } else {
        $failures++
        Write-Output "FAIL: $($case.Name)"
        Write-Output "  Expected: $($case.Expected)"
        Write-Output "  Actual: $($actual -join ' | ')"
    }
}

Write-Output "$($cases.Count - $failures)/$($cases.Count) tests passed."
if ($failures -gt 0) { exit 1 }
