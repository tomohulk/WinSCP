#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

Describe "Rename-WinSCPItem" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Rename-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Rename-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of Rename-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}
