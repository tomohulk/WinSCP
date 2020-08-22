#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Get-WinSCPHostKeyFingerprint" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPHostKeyFingerprint.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPHostKeyFingerprint.ps1"
        }
        
        It "Invoke-ScriptAnalyzer of Get-WinSCPSshHostKeyFingerprint results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
