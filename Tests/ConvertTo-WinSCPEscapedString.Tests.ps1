#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'ConvertTo-WinSCPEscapedString' {
    Context "ConvertTo-WinSCPEscapedString -FileMask 'FileNameWith*.txt'" {
        $escapedString = ConvertTo-WinSCPEscapedString -FileMask 'FileNameWith*.txt'

        It 'Star in file name should be escaped.' {
            $escapedString | Should BeExactly 'FileNameWith[*].txt'
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\ConvertTo-WinSCPEscapedString.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\ConvertTo-WinSCPEscapedString.ps1

        It 'Invoke-ScriptAnalyzer results of ConvertTo-WinSCPEscapedString count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP