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
}

Remove-Module -Name WinSCP