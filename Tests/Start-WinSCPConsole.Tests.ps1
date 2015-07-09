#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'Start-WinSCPConsole' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Start-WinSCPConsole.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Start-WinSCPConsole.ps1 -ExcludeRule PSAvoidUsingInternalURLs

        It 'Invoke-ScriptAnalyzer of Start-WinSCPConsole results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP