#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'New-WinSCPItem' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\New-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Get-WinSCPItemChecksum.ps1

        It 'Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP