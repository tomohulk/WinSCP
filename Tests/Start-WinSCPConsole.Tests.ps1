#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Start-WinSCPConsole' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Start-WinSCPConsole.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Start-WinSCPConsole.ps1 -ExcludeRule PSAvoidUsingInternalURLs

        It 'Invoke-ScriptAnalyzer of Start-WinSCPConsole results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}