$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path


#region LoadAssemblies

switch ($PSVersionTable.PSEdition) {
    "Core" {
        Add-Type -Path "${moduleRoot}\lib\netstandard2.0\WinSCPnet.dll"
        break;
    }

    "Desktop" {
        Add-Type -Path "${moduleRoot}\lib\net40\WinSCPnet.dll"
        break;
    }

    default {
        Write-Error -Message "Failed to find a compatiable WinSCP Assembly."
        exit
    }
}

#endregion LoadAssemblies


#region LoadFunctions

$paths = @(
    "Private",
    "Public"
)

foreach ($path in $paths) {
    "${moduleRoot}\${path}\*.ps1" | 
        Resolve-Path | 
            ForEach-Object { 
	            . $_.ProviderPath 
            }
}

#endregion LoadFunctions


#region Aliases

New-Alias -Name "Enter-WinSCPSession" -Value "New-WinSCPSession"
New-Alias -Name "Open-WinSCPSession" -Value "New-WinSCPSession"

New-ALias -Name "Close-WinSCPSession" -Value "Remove-WinSCPSession"
New-Alias -Name "Exit-WinSCPSession" -Value "Remove-WinSCPSession"

#endregion Aliases
