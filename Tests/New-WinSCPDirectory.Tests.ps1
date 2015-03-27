Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "New-WinSCPDirectory" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }

    $params = @{
        HostName = $env:COMPUTERNAME
        UserName = "MyUser"
        Password = "MyPassword"
        Protocol = "Ftp"
    }

    Context "Receive-WinSCPSession -WinSCPSession `$session -Path `"./Folder`"" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory

        It "Ftp directory should exist." {
            Test-Path -Path $ftp | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It "Session should be open." {
            $session.Opened | Should Be $true
        }

        $result = New-WinSCPDirectory -WinSCPSession $session -Path "./Folder"

        It "Result should be of type WinSCP.RemoteFileInfo" {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "$($ftp.FullName)\Folder should exsit." {
            Test-Path -Path "$($ftp.FullName)\Folder" | Should Not Be $false
        }

        It "Session should be closed." {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }
}