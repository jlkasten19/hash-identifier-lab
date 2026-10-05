# A format match is a clue, not proof of the hashing algorithm.
param([string]$Hash)

# Ask for input only when the caller did not supply the -Hash parameter.
if (-not $PSBoundParameters.ContainsKey('Hash')) {
    $Hash = Read-Host 'Enter a hash'
}

# Require exactly 32 hexadecimal characters, with no whitespace.
# \A and \z require the absolute beginning and end of the input.
if (($Hash.Length -eq 32) -and ($Hash -match '\A[0-9a-f]+\z')) {
    Write-Output 'Possible MD5 format.'
} else {
    Write-Output 'Does not match MD5 format.'
}
