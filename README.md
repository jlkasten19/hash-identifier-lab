# PowerShell Hash Identifier Lab

[![Tests](https://github.com/jlkasten19/hash-identifier-lab/actions/workflows/test.yml/badge.svg)](https://github.com/jlkasten19/hash-identifier-lab/actions/workflows/test.yml)

I started this project to get more comfortable with PowerShell. The idea was small: take a hash, check its length and characters, and print a message explaining whether it looks like an MD5 hash.

The script checks for exactly 32 hexadecimal characters: the digits `0-9` and letters `a-f`. Uppercase letters work too.

It says **"Possible MD5 format"** because the format alone isn't enough to identify the algorithm. An NTLM hash, for example, can also be 32 hexadecimal characters.

## Try it

You need Windows PowerShell 5.1 or PowerShell 7. There are no extra packages to install.

Open PowerShell in this project's folder and run:

```powershell
.\Identify-Hash.ps1
```

The `.\` means "from the current folder." When the script asks for a hash, paste this example:

```text
5d41402abc4b2a76b9719d911017c592
```

You should get:

```text
Possible MD5 format.
```

To test a value directly, use the `-Hash` parameter:

```powershell
.\Identify-Hash.ps1 -Hash 'gd41402abc4b2a76b9719d911017c592'
```

This example starts with `g`, which isn't a hexadecimal character. The result should be:

```text
Does not match MD5 format.
```

## What I practiced

I worked through the checks in the PowerShell console before putting them into a script:

- Storing input in a variable and using `Read-Host` to ask for it.
- Reading `.Length` and comparing it with `-eq`.
- Using `-match` to check the characters.
- Combining the checks with `-and`.
- Using `if` and `else` to choose the message.

One useful test was changing the first character from `5` to `g`. The length stayed at 32, but the character check failed. That made it clear why checking the length by itself wasn't enough.

I also ran into a couple of typing mistakes: `Legnth` instead of `Length`, and `-mathc` instead of `-match`. Working through those helped me connect the errors to the code I had actually entered.

## Tests

```powershell
.\tests\Test-IdentifyHash.ps1
```

There are 18 test cases covering valid examples, uppercase letters, wrong lengths, invalid characters, empty input, spaces, and newlines. GitHub Actions runs them in Windows PowerShell and PowerShell 7.

Testing also caught a detail in the original pattern: `$` can match just before a final newline. The saved script uses `\A` and `\z` to check the absolute start and end of the input. The walkthrough explains those symbols.

## Limits

This checks the shape of the text. It doesn't recover passwords, calculate hashes, or prove which algorithm produced a value. A result that doesn't match MD5 format could still be a valid hash of another type.

## Notes and walkthrough

- [Code and symbol walkthrough](docs/walkthrough.md)
- [Lab notes](docs/lab-notes.md)
- [Test results](docs/validation.md)

I used AI guidance while learning the commands, and AI assistance to finish the packaging, tests, and documentation. The console examples above are the ones I worked through during the lab.
