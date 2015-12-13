#Requires -Modules Pester,PSScriptAnalyzer

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

$ftp = "$pwd\Tests\Ftp"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hellow World!' -Force | Out-Null

Describe 'Get-WinSCPItem' {
    $credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString))

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem

        It 'Results of Get-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPItem Count should be one.' {
            $results.Count | Should Be 1
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    $paths = @(
        'SubDirectory',
        'SubDirectory/'
        '/SubDirectory',
        '/SubDirectory/',
        './SubDirectory',
        './SubDirectory/'
    )

    foreach ($path in $paths) {
        Context "`New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '$path'" {
            $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path $path

            It 'Results of Get-WinSCPItem should not be null.' {
                $results | Should Not Be Null
            }

            It 'Results of Get-WinSCPItem Count should be one.' {
                $results.Count | Should Be 1
            }

            It 'WinSCP Session should be closed.' {
                Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
            }
        }
    }

    $files = @(
        'TextFile.txt',
        'TextFile.txt/'
        '/TextFile.txt',
        '/TextFile.txt/',
        './TextFile.txt',
        './TextFile.txt/'
    )

    foreach ($file in $files) {
        Context "`New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '$file'" {
            $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path $file

            It 'Results of Get-WinSCPItem should not be null.' {
                $results | Should Not Be Null
            }

            It 'Results of Get-WinSCPItem Count should be one.' {
                $results.Count | Should Be 1
            }
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '/InvalidPath'" {
        It 'Results of Get-WinSCPItem should throw file not found.' {
            New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '/InvalidPath' -ErrorVariable e -ErrorAction SilentlyContinue
            
            $e.Count | Should Not Be 0
            $e | Should Not BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Get-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Get-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer results count for Get-WinSCPItem.ps1 should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
Remove-Module -Name WinSCP -Force