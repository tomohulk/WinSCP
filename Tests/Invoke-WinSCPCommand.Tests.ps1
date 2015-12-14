#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Invoke-WinSCPCommand' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Invoke-WinSCPCommand.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Invoke-WinSCPCommand.ps1

        It 'Invoke-ScriptAnalyzer of Invoke-WinSCPCommand results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP -Force