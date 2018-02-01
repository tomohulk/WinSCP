#requires -Modules Pester,PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
    Stop-Process -Force

Describe "Invoke-WinSCPCommand" {
    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\\Invoke-WinSCPCommand.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Invoke-WinSCPCommand.ps1"

        It "Invoke-ScriptAnalyzer of Invoke-WinSCPCommand results count should be 0." {
            $results.Count | 
                Should Be 0
        }
    }
}
