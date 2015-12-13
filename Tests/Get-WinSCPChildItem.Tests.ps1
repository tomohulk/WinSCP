#Requires -Modules Pester,PSScriptAnalyzer

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

$ftp = "$pwd\Tests\Ftp"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null

Describe 'Get-WinSCPChildItem' {
    $credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString))

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be two.' {
            $results.Count | Should Be 2
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be three.' {
            $results.Count | Should Be 3
        }

        It 'WinSCP process should not exist.' {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse -Filter '*.txt'" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse -Filter '*.txt'

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be two.' {
            $results.Count | Should Be 2
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    $paths = @(
        '.',
        '/',
        './'
    )

    foreach ($path in $paths) {
        Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Path '$path'" {
            $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Path $path

            It 'Results of Get-WinSCPChildItem should not be null.' {
                $results | Should Not Be Null
            }

            It 'Results of Get-WinSCPChildItem Count should be two.' {
                $results.Count | Should Be 2
            }

            It 'WinSCP process should not exist.' {
                Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
            }
        }
    }

    Context "`$session = New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp; Get-WinSCPChildItem -WinSCPSession `$session -Recurse -Filter '*.txt'" {
        $session = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp
        $results = Get-WinSCPChildItem -WinSCPSession $session -Recurse -Filter '*.txt'
        
        It 'WinSCP Session should be open.' {
            $session.Opened | Should Be $true
        }

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be two.' {
            $results.Count | Should Be 2
        }

        It 'WinSCP Session should be closed.' {
            Remove-WinSCPSession -WinSCPSession $session
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Path '/InvalidPath'" {
        It 'Results of Get-WinSCPChildItem should Write-Error file not found.' {
            New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Path '/InvalidPath' -ErrorVariable e -ErrorAction SilentlyContinue
            
            $e | Should Not BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Get-WinSCPChildItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Get-WinSCPChildItem.ps1

        It 'Invoke-ScriptAnalyzer of Get-WinSCPChildItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
Remove-Module -Name WinSCP -Force