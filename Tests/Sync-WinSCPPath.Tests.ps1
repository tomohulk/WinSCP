#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Sync-WinSCPPath' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\New-WinSCPPath.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Sync-WinSCPPath.ps1

        It 'Invoke-ScriptAnalyzer of Sync-WinSCPPath results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}
