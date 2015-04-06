Param ($server,$username,$password)


Describe 'New-WinSCPDirectory' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should Be $true
        (Get-Module -Name WinSCP).Path | Should Be "$($env:USERPROFILE)\Documents\GitHub\WinSCP\WinSCP.psm1"
    }

    $params = @{
        HostName = $server
        UserName = $username
        Password = $password
        Protocol = 'Ftp'
    }

    Context 'New-WinSCPDirectory -WinSCPSession $session -Path "./Folder"' {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory

        It "$($ftp.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = New-WinSCPDirectory -WinSCPSession $session -Path './Folder'

        It 'Result should be of type WinSCP.RemoteFileInfo.' {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "$($ftp.FullName)\Folder should exsit." {
            Test-Path -Path "$($ftp.FullName)\Folder" | Should Not Be $false
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }

    Context 'New-WinSCPDirectory -WinSCPSession $session -Path "./Folder/SubFolder"' {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory

        It "$($ftp.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = New-WinSCPDirectory -WinSCPSession $session -Path './Folder/SubFolder'

        It 'Result should be of type WinSCP.RemoteFileInfo.' {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "$($ftp.FullName)\Folder\SubFolder should exsit." {
            Test-Path -Path "$($ftp.FullName)\Folder\SubFolder" | Should Not Be $false
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }
}