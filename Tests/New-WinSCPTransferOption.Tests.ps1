#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'New-WinSCPTransferOption' {
    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\New-WinSCPTransferOption.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\New-WinSCPTransferOption.ps1

        It 'Invoke-ScriptAnalyzer of New-WinSCPTransferOption results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}