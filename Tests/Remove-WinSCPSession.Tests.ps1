#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force


Describe "Remove-WinSCPSession" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPSession.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Remove-WinSCPSession.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}
