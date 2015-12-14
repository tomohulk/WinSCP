#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'Test-WinSCPPath' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Test-WinSCPPath.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Test-WinSCPPath.ps1

        It 'Invoke-ScriptAnalyzer of Test-WinSCPPath results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP -Force