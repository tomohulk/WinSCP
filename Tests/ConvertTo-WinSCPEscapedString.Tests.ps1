#requires -Modules Pester,PSScriptAnalyzer

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

Describe 'ConvertTo-WinSCPEscapedString' {
    Context "ConvertTo-WinSCPEscapedString -FileMask 'FileNameWith*.txt'" {
        $escapedString = ConvertTo-WinSCPEscapedString -FileMask 'FileNameWith*.txt'

        It 'Star in file name should be escaped.' {
            $escapedString | Should BeExactly 'FileNameWith[*].txt'
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\ConvertTo-WinSCPEscapedString.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\ConvertTo-WinSCPEscapedString.ps1

        It 'Invoke-ScriptAnalyzer results of ConvertTo-WinSCPEscapedString count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP -Force