#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Start-WinSCPConsole" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Start-WinSCPConsole.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Start-WinSCPConsole.ps1"
        }

        It "Invoke-ScriptAnalyzer of Start-WinSCPConsole results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
