# PowerShell Hash Identifier Lab

[![Tests](https://github.com/jlkasten19/hash-identifier-lab/actions/workflows/test.yml/badge.svg)](https://github.com/jlkasten19/hash-identifier-lab/actions/workflows/test.yml)

A beginner cybersecurity lab that checks whether text has **32 hexadecimal characters**, the common representation of an MD5 digest. Built as a guided exercise in PowerShell variables, input, properties, comparisons, regular expressions, conditionals, and negative testing.

**A matching format suggests a possibility; it cannot identify the algorithm with certainty.** Other values, including NTLM hashes and random hexadecimal strings, can have the same shape. This program does not generate, crack, decrypt, or verify a hash against its original data.

## Run the lab

Requires Windows PowerShell 5.1 or PowerShell 7. No external modules or package installation is needed.

Open PowerShell in the downloaded or cloned repository folder. Run:

```powershell
.\Identify-Hash.ps1
```

The leading dot and backslash (`.\`) mean "from the current folder." `Identify-Hash.ps1` is the script filename; `.ps1` is the PowerShell script extension.

When asked `Enter a hash`, enter this public example without quotation marks:

```text
5d41402abc4b2a76b9719d911017c592
```

Expected result:

```text
Possible MD5 format.
```

You can also supply input directly:

```powershell
.\Identify-Hash.ps1 -Hash 'gd41402abc4b2a76b9719d911017c592'
```

`-Hash` is a named parameter: it passes the following text to the script. Single quotation marks surround the literal text. This example replaces the first character with `g`, which is not hexadecimal, while preserving the length.

Expected result:

```text
Does not match MD5 format.
```

If Windows blocks a downloaded script, read the file and the error before proceeding; this lab does not require disabling execution-policy protections.

## How it works

```text
Read input -> length is 32 AND every character is hexadecimal?
                 yes -> Possible MD5 format.
                 no  -> Does not match MD5 format.
```

The script accepts upper- and lowercase hexadecimal letters. It rejects empty input, spaces, newlines, non-hexadecimal characters, and other lengths. Whitespace is rejected rather than silently removed. A negative result only means the input does not have the supported MD5-style representation; it could be a different hash format.

The original learning exercise used `^[0-9a-f]+$`. The finished script uses `\A[0-9a-f]+\z` so a trailing newline cannot satisfy the end anchor. The separate length and character checks remain visible for learning.

## Learn the code

- [Symbol-by-symbol walkthrough](docs/walkthrough.md): what each operator, bracket, quote, and command means.
- [Lab notes](docs/lab-notes.md): the exercise, mistakes encountered, and observed results.
- [Validation results](docs/validation.md): automated cases and interactive checks.

This repository grew from a hands-on, AI-guided learning session. The console exercises were performed by the learner; packaging, additional tests, and documentation were completed with AI assistance. The aim is to understand, reproduce, and explain the code.

## Run the tests

```powershell
.\tests\Test-IdentifyHash.ps1
```

The test runner invokes the actual script with 18 independently chosen inputs and checks its output. It exits with code `1` if a case fails so GitHub Actions can detect failures. No Pester installation is required. CI runs the tests with both Windows PowerShell and PowerShell 7 on Windows.

## Files

| File | Purpose |
| --- | --- |
| `Identify-Hash.ps1` | Small interactive or parameter-driven identifier |
| `tests/Test-IdentifyHash.ps1` | Positive, negative, boundary, and whitespace cases |
| `docs/walkthrough.md` | Beginner explanation of the code and symbols |
| `docs/lab-notes.md` | Guided learning record |
| `docs/validation.md` | Reproducible validation evidence |
| `.github/workflows/test.yml` | Automated checks for future pushes and pull requests |

## Portfolio description

> Completed a guided PowerShell lab that validates candidate MD5-format strings using length and hexadecimal checks; documented the syntax, tested positive and negative inputs, and added repeatable automated validation.

This is a foundational scripting project. It demonstrates input validation and careful interpretation of results; it does not establish experience with production security monitoring or password recovery.
