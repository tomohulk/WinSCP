Param ($server,$username,$password)


Describe 'Receive-WinSCPItem' {
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

    Context "Receive-WinSCPSession -WinSCPSession `$session -RemotePath `"./Folder`" -LocalPath `"$(Get-Location)\Folder`"" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $folder = New-Item -Path "$ftp\Folder" -ItemType Directory
        $local = New-Item -Path "$(Get-Location)\Local" -ItemType Directory

        It "$($ftp.FullName), $($folder.FullName) and $($local.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
            Test-Path -Path $folder | Should Be $true
            Test-Path -Path $local | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath './Folder' -LocalPath "$local\Folder"

        It "Folder should exist in $($ftp.FullName) and $($local.FullName) directories." {
            $result.IsSuccess | Should Not Be $false
            Test-Path -Path "$($ftp.FullName)\Folder" | Should Not Be $false
            Test-Path -Path "$($local.FullName)\Folder" | Should Not Be $false
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
        Remove-Item -Path $local -Confirm:$false -Force -Recurse
    }

    Context "Receive-WinSCPSession -WinSCPSession `$session -RemotePath `"./Folder`" -LocalPath `"$(Get-Location)\Folder`" -Remove" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $local = New-Item -Path "$(Get-Location)\Local" -ItemType Directory
        $folder = New-Item -Path "$($ftp.FullName)\Folder" -ItemType Directory

        It "$($ftp.FullName), $($folder.FullName) and $($local.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
            Test-Path -Path $folder | Should Be $true
            Test-Path -Path $local | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath './Folder' -LocalPath "$local\Folder" -Remove

        It "Folder should exist only in $local directory." {
            $result.IsSuccess | Should Not Be $false
            Test-Path -Path "$($ftp.FullName)\Folder" | Should Be $false
            Test-Path -Path "$($local.FullName)\Folder" | Should Not Be $false
        }

        It 'Session should be closed.' {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
        Remove-Item -Path $local -Confirm:$false -Force -Recurse
    }
}