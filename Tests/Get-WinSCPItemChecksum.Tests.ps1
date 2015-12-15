#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Get-WinSCPItemChecksum' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Get-WinSCPItemChecksum.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Get-WinSCPItemChecksum.ps1

        It 'Invoke-ScriptAnalyzer of Get-WinSCPItemChecksum results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}