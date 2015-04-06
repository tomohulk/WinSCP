Param ($server,$username,$password)


Describe 'Close-WinSCPSession' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should Be $true
        (Get-Module -Name WinSCP).Path | Should Be "$($env:USERPROFILE)\Documents\GitHub\WinSCP\WinSCP.psm1"
    }

    Context "Close-WinSCPSession -WinSCPSession (Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -HostName $env:COMPUTERNAME -UserName $username -Password $password -Protocol Ftp))" {
        $params = @{
            HostName = $env:COMPUTERNAME
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
}