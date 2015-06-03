if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Import-Module -Name ..\WinSCP.psd1


Describe 'New-WinSCPSession' {
    Context "-HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp" {
        $session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp

        It 'Session should be of type WinSCP.Session.' {
            $session.GetType() | Should Be WinSCP.Session
        }

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        It "Hostname should be $env:COMPUTERNAME." {
            $session
        }

        Remove-WinSCPSession -WinSCPSession $session
    }

    Context "-HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocal Ftp -SessionLogPath $env:TEMP\Session.log -DebugLogPath $env:TEMP\Debug.log" {
                $session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp -SessionLogPath "$env:TEMP\Session.log" -DebugLogPath "$env:TEMP\Debug.log"

        It 'Session should be of type WinSCP.Session.' {
            $session.GetType() | Should Be WinSCP.Session
        }

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        It "$env:TEMP\Session.log should exist." {
            Test-Path -Path "$env:TEMP\Session.log" | Should Be $true
        }

        It "$env:TEMP\Debug.log should exist." {
            Test-Path -Path "$env:TEMP\Debug.log" | Should Be $true
        }

        Remove-WinSCPSession -WinSCPSession $session
    }
}