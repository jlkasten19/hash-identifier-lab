# Lab notes

This lab records guided learning with AI assistance. The exercise focused on one small PowerShell format check and on understanding each piece of its syntax. It did not build an advanced threat-analysis tool or add encryption, decryption, hash generation, or cracking.

## Manual observations

The sample value used during the exercise was:

```text
5d41402abc4b2a76b9719d911017c592
```

| Check | Observation |
| --- | --- |
| `$hash.Length` | `32` |
| `$hash.Length -eq 32` | `True` |
| `$hash -match '^[0-9a-f]+$'` | `True` for the sample |
| Combined length and character checks with `-and` | `True` for the sample |
| First character changed to `g` (`gd41402abc4b2a76b9719d911017c592`) | Length stayed `32`; the character check became `False` |
| Invalid-character branch | `Does not match MD5 format.` |

`Read-Host` was used to practice entering a value interactively, and the same value can also be supplied with `-Hash`.

## Lessons from the syntax

- A JavaScript `import` statement was entered into PowerShell during practice. The lesson was to confirm which shell and language a command belongs to before running it.
- `Length` was briefly mistyped as `Legnth`; property names must be spelled correctly.
- `-match` was briefly mistyped as `-mathc`; PowerShell operators must be spelled correctly.
- Literal newlines or spaces inside the quoted output message appeared in the printed message. Similarly, whitespace placed inside an input string becomes part of the value being checked.
- The learned pattern `^[0-9a-f]+$` is useful for seeing ordinary regex anchors. The finished script uses `\A[0-9a-f]+\z`, whose anchors require the absolute start and end so a trailing newline is rejected.

## Final behavior

The script accepts a string only when its length is 32 and every character is hexadecimal. Empty strings, whitespace (including a trailing newline), nonhex characters, and other lengths are rejected. Uppercase and lowercase hexadecimal letters are accepted because ordinary PowerShell `-match` is case-insensitive.

The result remains a shape check. A matching 32-hex value may be MD5, but the same shape can belong to another 128-bit hash format such as NTLM. The message `Does not match MD5 format.` does not mean that the value is invalid as a hash in general.
