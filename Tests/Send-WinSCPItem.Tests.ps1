#requires -Modules Pester,PSScriptAnalyzer

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Send-WinSCPItem' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Send-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Send-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Send-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP -Force