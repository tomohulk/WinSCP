$paths = @(
    'Private',
    'Public'
)

foreach ($path in $paths) {
    "$(Split-Path -Path $MyInvocation.MyCommand.Path)\$path\*.ps1" | Resolve-Path | ForEach-Object { 
	    . $_.ProviderPath 
    }
}
<<<<<<< HEAD

New-Alias -Name 'Enter-WinSCPSession' -Value 'New-WinSCPSession'
New-Alias -Name 'Exit-WinSCPSession' -Value 'Remove-WinSCPSession'
=======
>>>>>>> master
