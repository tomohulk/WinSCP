#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "New-WinSCPTransferOption" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPTransferOption.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPTransferOption.ps1"
        }
        
        It "Invoke-ScriptAnalyzer of New-WinSCPTransferOption results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
