Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "Close-WinSCPSession" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }

    Context "Close-WinSCPSession -WinSCPSession (Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COMPUTERNAME -UserName MyUser -Password MyPassword -Protocol Ftp))" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = "MyUser"
            Password = "MyPassword"
            Protocol = "Ftp"
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It "Session should Opened and be of Type WinSCP.Session." {
            $session.Opened | Should Not Be $false
            $session.GetType() | Should Be WinSCP.Session
        }

        It "Session should be closed." {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }
    }
}