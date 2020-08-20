#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

BeforeAll {
    Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
        Stop-Process -Force
}

Describe "Copy-WinSCPItem" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Copy-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Copy-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of Copy-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
