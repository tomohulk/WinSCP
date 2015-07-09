#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'Receive-WinSCPItem' {
    $ftp = "$pwd\Tests\Ftp"
    New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force
    New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hellow World!' -Force
    $temp = New-Item "$pwd\Tests\Temp" -ItemType Directory -Force

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/TextFile.txt -Destination $($temp.FullName)" {
        $results = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/TextFile.txt' -Destination $temp.FullName

        It 'Results of Get-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of transfer should be success.' {
            $results.IsSuccess | Should Be $true
        }

        It "TextFile.txt should exist in $temp" {
            Test-Path -Path "$($temp.FullName)\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Receive-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Receive-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Receive-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }

    Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
    Remove-Item -Path $temp -Recurse -Force -Confirm:$false
}

Remove-Module -Name WinSCP