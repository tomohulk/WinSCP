#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

Describe "New-WinSCPSessionOption" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPSessionOption.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPSessionOption.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPSessionOption results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}
