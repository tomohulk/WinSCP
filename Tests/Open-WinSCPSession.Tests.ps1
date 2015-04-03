Param($server,$username,$password)

Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe 'Open-WinSCPSession' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should be $true
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName $username -Password $password -Protocol Ftp)" {
        $params  = @{
            HostName = $server
            UserName = $username
            Password = $password
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)
        
        It 'Session should Opened and be of Type WinSCP.Session.' {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName $username -Password $password -Protocol Ftp) -SessionLogPath `"$(Get-Location)\Session.log`"" {
        $params  = @{
            HostName = $server
            UserName = $username
            Password = $password
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params) -SessionLogPath "$(Get-Location)\Session.log"

        It 'Session should Opened and be of Type WinSCP.Session.' {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It "$(Get-Location)\Session.log should be exist." {
            Test-Path -Path "$(Get-Location)\Session.log" | Should Be $true 
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path "$(Get-Location)\Session.log" -Confirm:$false -Force
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName $username -Password $password -Protocol Ftp) -DebugLogPath `"$(Get-Location)\Debug.log`"" {
        $params = @{
            HostName = $server
            UserName = $username
            Password = $password
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params) -DebugLogPath "$(Get-Location)\Debug.log"

        It 'Session should Opened and be of Type WinSCP.Session.' {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It "$(Get-Location)\Debug.log should exist." {
            Test-Path -Path "$(Get-Location)\Debug.log" | Should Be $true
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }
        
        Remove-Item -Path "$(Get-Location)\Debug.log" -Confirm:$false -Force
    }
}