#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Remove-WinSCPItem" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPItem.ps1"
        }
        
        It "Invoke-ScriptAnalyzer of Remove-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
