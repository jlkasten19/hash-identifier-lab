# Validation record

Validated locally on October 5, 2026. The public GitHub Actions run provides a second, reproducible check against the published commit.

## Method

The test runner calls the real `Identify-Hash.ps1` script and checks that exactly one expected message is returned for each supplied value. Before implementation, all 18 tests failed against a placeholder implementation. After implementation, all 18 passed under both Windows PowerShell 5.1 and PowerShell 7.6.5.

The cases use public examples and deliberately invalid strings. No personal or credential-derived hashes are needed.

| Case | Expected result | Local result |
| --- | --- | --- |
| Known lowercase 32-hex example | Possible MD5 format | Pass |
| Uppercase letters | Possible MD5 format | Pass |
| Mixed-case letters | Possible MD5 format | Pass |
| 32 digits | Possible MD5 format | Pass |
| 32 hexadecimal letters | Possible MD5 format | Pass |
| Another algorithm's 32-hex representation | Possible MD5 format | Pass |
| Replace first character with `g` | Does not match MD5 format | Pass |
| Empty input | Does not match MD5 format | Pass |
| Plain text `hello` | Does not match MD5 format | Pass |
| 31 hexadecimal characters | Does not match MD5 format | Pass |
| 33 hexadecimal characters | Does not match MD5 format | Pass |
| 40 hexadecimal characters | Does not match MD5 format | Pass |
| Leading space | Does not match MD5 format | Pass |
| Trailing space | Does not match MD5 format | Pass |
| Internal space at total length 32 | Does not match MD5 format | Pass |
| 31 hexadecimal characters plus newline | Does not match MD5 format | Pass |
| 32 hexadecimal characters plus newline | Does not match MD5 format | Pass |
| Punctuation at total length 32 | Does not match MD5 format | Pass |

The other-algorithm example is intentionally accepted. This documents the limitation of format-based identification; it is not evidence that the value was produced by MD5.

## Input modes

The optional `-Hash` parameter is exercised by all automated cases, including an explicitly empty argument. The prompt path was also run through the actual PowerShell process with the valid and `g` examples supplied through standard input; both produced the expected messages.

## Reproduce

PowerShell commands, run from the repository folder:

```powershell
powershell.exe -NoProfile -File .\tests\Test-IdentifyHash.ps1
pwsh -NoProfile -File .\tests\Test-IdentifyHash.ps1
```

`powershell.exe` starts Windows PowerShell; `pwsh` starts PowerShell 7 if installed. `-NoProfile` skips personal startup customizations. `-File` identifies the script to run. `.\` means the current directory. Each hyphen here introduces a named command parameter. Test failures exit with code 1; success exits with code 0.

The test harness uses arrays (`@(...)`) of named test cases, hash tables (`@{...}`), a `foreach` loop, and the call operator (`&`) to run the real script. These are supporting automation concepts beyond the initial lab. The beginner walkthrough focuses on understanding the identifier itself first.

## Limitations

These tests validate the defined format rules, not cryptographic strength or algorithm identification accuracy. The script does not inspect files or networks and does not store the submitted input. It supports this one representation only. Shell history may retain commands containing a `-Hash` argument; use the public examples for this learning exercise.
