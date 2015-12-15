#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Remove-WinSCPSession' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Remove-WinSCPSession.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Remove-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Remove-WinSCPSession results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}