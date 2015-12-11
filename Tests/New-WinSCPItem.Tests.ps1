#requires -Modules Pester,PSScriptAnalyzer

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

$ftp = "$pwd\Tests\Ftp"
New-Item -Path "$ftp"-ItemType Directory -Force | Out-Null

Describe 'New-WinSCPItem' {
    $credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString))

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'TestFolder' -ItemType Directory" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'TestFolder' -ItemType Directory

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'TestFolder' -ItemType Directory -Force" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'TestFolder' -ItemType Directory -Force

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'Test.txt'" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'Test.txt'

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'Text.txt' -Force" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Name 'Test.txt' -Force

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }
    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'TestFolder' -ItemType Directory" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'TestFolder' -ItemType Directory

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'TestFolder' -ItemType Directory -Force" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'TestFolder' -ItemType Directory -Force

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'Test.txt'" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'Test.txt'

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'Text.txt' -Force" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | New-WinSCPItem -Path 'TestFolder' -Name 'Test.txt' -Force

        It 'Results of New-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of New-WinSCPItem should be success.' {
            $results.IsSuccess | Should Be True
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\New-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\New-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
Remove-Module -Name WinSCP -Force