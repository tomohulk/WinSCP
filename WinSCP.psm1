"$(Split-Path -Path $MyInvocation.MyCommand.Path)\Functions\*.ps1" | Resolve-Path | % { . $_.ProviderPath }

Set-Alias -Name 'Open-WinSCPSession' -Value 'New-WinSCPSession'