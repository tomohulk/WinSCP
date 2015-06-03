$DefaultWinSCPSession = $null

"$(Split-Path -Path $MyInvocation.MyCommand.Path)\Functions\*.ps1" | Resolve-Path | % { . $_.ProviderPath }