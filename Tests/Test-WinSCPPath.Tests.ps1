#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'Test-WinSCPPath' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Test-WinSCPPath.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Test-WinSCPPath.ps1

        It 'Invoke-ScriptAnalyzer of Test-WinSCPPath results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP