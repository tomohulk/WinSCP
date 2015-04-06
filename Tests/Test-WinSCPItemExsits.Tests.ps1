Param ($server,$username,$password)


Describe 'Test-WinSCPItemExists' {
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

    Context 'Test-WinSCPItemExists -WinSCPSession $session -Path "./Folder"' {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $folder = New-Item -Path "$ftp\Folder" -ItemType Directory

        It "$($ftp.FullName) and $($folder.FullName) should exist." {
            Test-Path $ftp.FullName | Should Not Be $false
            Test-Path $folder.FullName | Should Not Be $false
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be opened.' {
            $session.Opened | Should Be $true
        }

        It 'Folder object should exist.' {
            Test-WinSCPItemExists -WinSCPSession $session -Path './Folder' | Should Not Be $false
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }

    Context 'Test-WinSCPItemExists -WinSCPSession $session -Path "./Folder/File.txt"' {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $folder = New-Item -Path "$ftp\Folder" -ItemType Directory

        It "$($ftp.FullName) and $($folder.FullName) should exist." {
            Test-Path $ftp.FullName | Should Not Be $false
            Test-Path $folder.FullName | Should Not Be $false
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be opened.' {
            $session.Opened | Should Be $true
        }

        It 'Folder object should exist.' {
            Test-WinSCPItemExists -WinSCPSession $session -Path './Folder' | Should Not Be $false
        }

        It 'File object should not exist.' {
            Test-WinSCPItemExists -WinSCPSession $session -Path './Folder/File.txt' | Should Not Be $true
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
    }
}