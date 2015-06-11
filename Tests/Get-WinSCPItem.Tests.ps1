if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'Get-WinSCPItem' {
    $ftp = "$pwd\Tests\Ftp"
    New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force
    New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hellow World!' -Force

    Context "New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp | Get-WinSCPItem" {
        $results = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp | Get-WinSCPItem

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be one.' {
            $results.Count | Should Be 1
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "`$session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp; Get-WinSCPItem -WinSCPSession $session -Path '/SubDirectory'" {
        $session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp
        $results = Get-WinSCPItem -WinSCPSession $session -Path '/SubDirectory'
        
        It 'WinSCP Session should be open.' {
            $session.Opened | Should Be $true
        }

        It 'Results of Get-WinSCPChildItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of Get-WinSCPChildItem Count should be one.' {
            $results.Count | Should Be 1
        }

        It 'WinSCP Session should be closed.' {
            Remove-WinSCPSession -WinSCPSession $session
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Get-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\Get-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer results count should be 0.' {
            $results.Count | Should Be 0
        }
    }

    Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
}

Remove-Module -Name WinSCP