# Walkthrough: identify a possible MD5-format string

This is a guided learning lab with AI assistance. It practices reading a PowerShell script and checking a string's shape. It is not an advanced threat tool, and it does not claim to identify a hash algorithm with certainty.

## What the check means

The script accepts a value when it has exactly 32 hexadecimal characters (`0` through `9`, or `a` through `f`). PowerShell's ordinary `-match` operator is case-insensitive, so uppercase hexadecimal letters are accepted too.

“Possible MD5 format” describes the shape only. A 32-character hexadecimal value can represent other 128-bit formats, including NTLM. The script does not decrypt, encrypt, generate, crack, or validate a hash's value.

## Run the script

From the folder containing `Identify-Hash.ps1`, let the script prompt for input:

```powershell
.\Identify-Hash.ps1
```

Enter the sample value when prompted:

```text
5d41402abc4b2a76b9719d911017c592
```

The direct-parameter form supplies the same value without a prompt:

```powershell
.\Identify-Hash.ps1 -Hash '5d41402abc4b2a76b9719d911017c592'
```

For a value with one invalid character, run:

```powershell
.\Identify-Hash.ps1 -Hash 'gd41402abc4b2a76b9719d911017c592'
```

That value is still 32 characters long, but `g` is not hexadecimal, so the result is `Does not match MD5 format.`

## Read the script

```powershell
param([string]$Hash)

if (-not $PSBoundParameters.ContainsKey('Hash')) {
    $Hash = Read-Host 'Enter a hash'
}

if (($Hash.Length -eq 32) -and ($Hash -match '\A[0-9a-f]+\z')) {
    Write-Output 'Possible MD5 format.'
} else {
    Write-Output 'Does not match MD5 format.'
}
```

Read it from top to bottom:

1. `param(...)` declares the script's input. `[string]` says that `Hash` is text, and `$Hash` names the variable that holds it.
2. `-not` reverses the test. `$PSBoundParameters` is PowerShell's collection of parameters supplied by the caller. `.ContainsKey('Hash')` asks whether the caller supplied the named `Hash` parameter. If it was not supplied, `Read-Host 'Enter a hash'` prompts and assigns the response to `$Hash`.
3. The final `if` requires both tests inside its parentheses. `$Hash.Length` reads the string length; `-eq 32` checks that it equals 32. The second test uses `-match` with the regular expression `\A[0-9a-f]+\z`.
4. If both tests are true, `Write-Output` prints `Possible MD5 format.`. `else` runs when either test is false and prints `Does not match MD5 format.`.

## Name the symbols

| Symbol or word | Meaning in this script |
| --- | --- |
| `$` | **Dollar sign:** marks a PowerShell variable, such as `$Hash` or `$PSBoundParameters`. |
| `=` | **Equals sign / assignment operator:** stores the value on the right in the variable on the left. |
| `.` | **Dot / member-access operator:** `$Hash.Length` reads a property, and `.ContainsKey(...)` calls a method (an operation attached to a value). |
| `[]` | **Square brackets:** in `[string]`, declare a text type; in `[0-9a-f]`, surround a regular-expression character class. |
| `()` | **Parentheses:** group a condition for `if`; after `ContainsKey`, hold the method argument. |
| `{}` | **Curly braces:** enclose the statements that belong to `if` or `else`. |
| `'...'` | **Single quotation marks:** surround literal text such as `'Hash'` and preserve the regex text. |
| `"..."` | **Double quotation marks:** also surround text, but allow PowerShell to insert variable values inside it. Used in earlier console messages. |
| `#` | **Number sign / comment marker:** starts an explanation for the reader; PowerShell ignores the rest of that line. |
| `-not`, `-eq`, `-and`, `-match` | Hyphen-prefixed PowerShell operators meaning not, equals, both conditions, and regular-expression match. |
| `-Hash` | A named parameter label; the hyphen is part of the parameter syntax. |
| `Write-Output`, `Read-Host` | Hyphenated PowerShell command names: one writes output and one reads prompted input. |

The hyphen has a different job in the regex range `0-9`: there it means every character from `0` through `9`. In `a-f`, it means the letters from `a` through `f`. It is not a PowerShell command-name prefix in those ranges.

## Understand the regular expression

`[0-9a-f]` matches one hexadecimal character. The `+` (plus sign / quantifier) means “one or more” of the preceding character class. The `\` is a backslash used by the regular-expression engine to introduce an anchor: `\A` requires the absolute beginning of the string, and `\z` requires the absolute end. It is regex syntax here, not a PowerShell command separator.

During the interactive exercise, the looser pattern `^[0-9a-f]+$` was tested and returned `True` for the good sample. `^` (caret) and `$` (dollar sign) are start/end anchors, but in the .NET regular-expression engine `$` can also match just before a final newline. The script therefore uses `\A` and `\z` for strict boundaries. This makes trailing newlines and other whitespace fail the format check.

The length test supplies the other half of the rule. Together, the two tests accept exactly 32 hexadecimal characters and reject empty input, whitespace, nonhex characters, and other lengths. Because `-match` is case-insensitive by default, uppercase hexadecimal letters pass; a case-sensitive `-cmatch` would behave differently.

## A useful interpretation

The output is a format observation, not proof that the value is an MD5 digest. Treat `Possible MD5 format.` as “this string has the expected 32-hex shape.” Treat `Does not match MD5 format.` as “this string does not have that shape,” not as a statement about every possible hash format.
