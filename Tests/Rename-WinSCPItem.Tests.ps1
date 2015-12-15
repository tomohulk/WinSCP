#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Rename-WinSCPItem' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Rename-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Rename-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Rename-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}