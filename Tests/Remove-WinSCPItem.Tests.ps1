#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

Describe "Remove-WinSCPItem" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of Remove-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}
