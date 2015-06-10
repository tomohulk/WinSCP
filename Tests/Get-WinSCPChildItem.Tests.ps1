if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'Get-WinSCPChildItem' {
    $ftp = "$pwd\Tests\Ftp"
    New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force
    New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hellow World!' -Force

    Context "New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp | Get-WinSCPChildItem" {
        $results = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp | Get-WinSCPChildItem

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

    Context "New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp | Get-WinSCPChildItem -Recurse" {
        $results = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be three.' {
            $results.Count | Should Be 3
        }

        It 'WinSCP process should not exist.' {
            Get-Process -Name WInSCP -ErrorAction SilentlyContinue | Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp | Get-WinSCPChildItem -Recurse -Filter '*.txt'" {
        $results = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp | Get-WinSCPChildItem -Recurse -Filter '*.txt'

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

    Context "`$session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp; Get-WinSCPChildItem -WinSCPSession `$session -Recurse -Filter '*.txt'" {
        $session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp
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

    <#Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Get-WinSCPChildItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Get-WinSCPChildItem.ps1

        It 'Invoke-ScriptAnalyzer results count should be 0.' {
            $results.Count | Should Be 0
        }
    }#>

    Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
}

Remove-Module -Name WinSCP