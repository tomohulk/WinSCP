Param ($server,$username,$password)

Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe 'Get-WinSCPDirectoryContents' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should be $true
    }

    $params = @{
        HostName = $server
        UserName = $username
        Password = $password
        Protocol = 'Ftp'
    }

    Context 'Get-WinSCPDirectoryContents -WinSCPSession $session -Path "./"' {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory

        It "$($ftp.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = Get-WinSCPDirectoryContents -WinSCPSession $session -Path "./"

        It 'object should be type WinSCP.RemoteDirectoryInfo.' {
            $result.GetType() | Should Be WinSCP.RemoteDirectoryInfo
        }

        It 'Directory should only contain parent path.' {
            $result.Files | Should Be ".."
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }
}