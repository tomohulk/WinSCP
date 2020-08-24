#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Test-WinSCPPath" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Test-WinSCPPath.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Test-WinSCPPath.ps1"
        }

        It "Invoke-ScriptAnalyzer of Test-WinSCPPath results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
