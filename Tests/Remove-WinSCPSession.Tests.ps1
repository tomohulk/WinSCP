#requires -Modules Pester, PSScriptAnalyzer, WinSCP
<# Disabling this test for the time being, the PSReviewUnusedParameter rule is being triggered incorrectly.  https://github.com/PowerShell/PSScriptAnalyzer/issues/1615.
Describe "Remove-WinSCPSession" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPSession.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPSession.ps1"
        }
        
        It "Invoke-ScriptAnalyzer of Remove-WinSCPSession results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
#>
