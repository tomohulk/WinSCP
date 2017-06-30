$paths = @(
    "Private",
    "Public"
)

foreach ($path in $paths) {
    "$(Split-Path -Path $MyInvocation.MyCommand.Path)\$path\*.ps1" | 
        Resolve-Path | 
            ForEach-Object { 
	            . $_.ProviderPath 
            }
}

# Add aliases.
New-Alias -Name "Enter-WinSCPSession" -Value "New-WinSCPSession"
New-Alias -Name "Open-WinSCPSession" -Value "New-WinSCPSession"

New-ALias -Name "Close-WinSCPSession" -Value "Remove-WinSCPSession"
New-Alias -Name "Exit-WinSCPSession" -Value "Remove-WinSCPSession"
