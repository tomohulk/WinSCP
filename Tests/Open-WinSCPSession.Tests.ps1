Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "Open-WinSCPSession" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName 'MyUser' -Password 'MyPassword' -Protocol Ftp)" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = 'MyUser'
            Password = 'MyPassword'
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)
        `
        It "Session should Opened and be of Type WinSCP.Session." {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        Close-WinSCPSession -WinSCPSession $session
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName 'MyUser' -Password 'MyPassword' -Protocol Ftp) -SessionLogPath `"$(Get-Location)\Session.log`"" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = 'MyUser'
            Password = 'MyPassword'
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params) -SessionLogPath "$(Get-Location)\Session.log"

        It "Session should Opened and be of Type WinSCP.Session." {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It "SessionLogPath should be exist." {
            Test-Path -Path "$(Get-Location)\Session.log" | Should Be $true 
        }

        Close-WinSCPSession -WinSCPSession $session

        Remove-Item -Path "$(Get-Location)\Session.log" -Confirm:$false -Force
    }

    Context "Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COOMPUTERNAME -UserName 'MyUser' -Password 'MyPassword' -Protocol Ftp) -DebugLogPath `"$(Get-Location)\Debug.log`"" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = 'MyUser'
            Password = 'MyPassword'
            Protocol = 'Ftp'
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params) -DebugLogPath "$(Get-Location)\Debug.log"

        It "Session should Opened and be of Type WinSCP.Session." {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It "DebugLogPath should be used." {
            Test-Path -Path "$(Get-Location)\Debug.log" | Should Be $true
        }

        Close-WinSCPSession -WinSCPSession $session

        Remove-Item -Path "$(Get-Location)\Debug.log" -Confirm:$false -Force
    }
}