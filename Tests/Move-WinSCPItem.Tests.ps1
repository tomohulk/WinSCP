#requires -Modules Pester,PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1 -Force

$ftp = "$pwd\Tests\Ftp"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null

Describe 'Move-WinSCPItem' {
    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/TextFile.txt' -Destination './SubDirectory'" {
        $results = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
            Move-WinSCPItem -Path '/TextFile.txt' -Destination './SubDirectory'

        It 'Results of Move-WinSCPItem should be null, -PassThru switch not used.' {
            $results | Should BeNullOrEmpty
        }

        It 'TextFile.txt should not exist in root.' {
            Test-Path -Path "$ftp\TextFile.txt" | Should Be $false
        }

        It 'TextFile.txt should exsist in /root/SubDirectory' {
            Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }

        Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/TextFile.txt' -Destination '/SubDirectory'" {
        $results = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
            Move-WinSCPItem -Path '/TextFile.txt' -Destination '/SubDirectory'

        It 'Results of Move-WinSCPItem should be null, -PassThru switch not used.' {
            $results | Should BeNullOrEmpty
        }

        It 'TextFile.txt should not exist in root.' {
            Test-Path -Path "$ftp\TextFile.txt" | Should Be $false
        }

        It 'TextFile.txt should exsist in /root/SubDirectory' {
            Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }

        Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/TextFile.txt' -Destination '/SubDirectory/'" {
        $results = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
            Move-WinSCPItem -Path '/TextFile.txt' -Destination '/SubDirectory/'

        It 'Results of Move-WinSCPItem should be null, -PassThru switch not used.' {
            $results | Should BeNullOrEmpty
        }

        It 'TextFile.txt should not exist in root.' {
            Test-Path -Path "$ftp\TextFile.txt" | Should Be $false
        }

        It 'TextFile.txt should exsist in /root/SubDirectory' {
            Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }

        Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/TextFile.txt' -Destination './SubDirectory/'" {
        $results = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
            Move-WinSCPItem -Path '/TextFile.txt' -Destination './SubDirectory/'

        It 'Results of Move-WinSCPItem should be null, -PassThru switch not used.' {
            $results | Should BeNullOrEmpty
        }

        It 'TextFile.txt should not exist in root.' {
            Test-Path -Path "$ftp\TextFile.txt" | Should Be $false
        }

        It 'TextFile.txt should exsist in /root/SubDirectory' {
            Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }

        Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/InvalidFile.txt' -Destination '/InvalidSubDirectory'" {
        It 'Results of Move-WinSCPItem should throw file not found.' {
            New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
                Move-WinSCPItem -Path '/InvalidFile.txt' -Destination '/InvalidSubDirectory' -ErrorVariable e -ErrorAction SilentlyContinue
            $e.Count | Should Not Be 0
            $e.Exception.Message | Should Be 'Could not find a part of the path.'
        }
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/TextFile.txt' -Destination '/InvalidSubDirectory'" {
        It 'Results of Move-WinSCPItem should throw path not found.' {
            New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | 
                Move-WinSCPItem -Path '/TextFile.txt' -Destination '/InvalidSubDirectory' -ErrorVariable e -ErrorAction SilentlyContinue
            $e.Count | Should Not Be 0
            $e.Exception.Message | Should Be 'Could not find a part of the path.'
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Move-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Move-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Move-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
Remove-Module -Name WinSCP -Force