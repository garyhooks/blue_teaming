

```
$obfuscated = 'obfuscated.code.here' 

# Decode the obfuscated string
$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($obfuscated))

# Print the decoded string
$decoded
```
