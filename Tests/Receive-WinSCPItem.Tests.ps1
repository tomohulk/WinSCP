Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "Receive-WinSCPItem" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }
    
    $params = @{
        HostName = $env:COMPUTERNAME
        UserName = "MyUser"
        Password = "MyPassword"
        Protocol = "Ftp"
    }

    Context "Receive-WinSCPSession -WinSCPSession `$session -RemotePath `"./Folder`" -LocalPath `"$(Get-Location)\Folder`"" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $folder = New-Item -Path "$ftp\Folder" -ItemType Directory
        $local = New-Item -Path "$(Get-Location)\Local" -ItemType Directory

        It "Ftp and Local directories should exist." {
            Test-Path -Path $ftp | Should Be $true
            Test-Path -Path $folder | Should Be $true
            Test-Path -Path $local | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It "Session should be open." {
            $session.Opened | Should Be $true
        }

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "./Folder" -LocalPath "$local\Folder"

        It "Folder should exist in $ftp and $local directories." {
            $result.IsSuccess | Should Not Be $false
            Test-Path -Path "$ftp\Folder" | Should Not Be $false
            Test-Path -Path "$local\Folder" | Should Not Be $false
        }

        It "Session should be closed." {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
        Remove-Item -Path $local -Confirm:$false -Force -Recurse
    }

    Context "Receive-WinSCPSession -WinSCPSession `$session -RemotePath `"./Folder`" -LocalPath `"$(Get-Location)\Folder`" -Remove" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $local = New-Item -Path "$(Get-Location)\Local" -ItemType Directory
        $folder = New-Item -Path "$ftp\Folder" -ItemType Directory

        It "Ftp and Local directories should exist." {
            Test-Path -Path $ftp | Should Be $true
            Test-Path -Path $folder | Should Be $true
            Test-Path -Path $local | Should Be $true
        }
        
        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It "Session should be open." {
            $session.Opened | Should Be $true
        }

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "./Folder" -LocalPath "$local\Folder" -Remove

        It "Folder should exist only in $local directory." {
            $result.IsSuccess | Should Not Be $false
            Test-Path -Path "$ftp\Folder" | Should Not Be $true
            Test-Path -Path "$local\Folder" | Should Not Be $false
        }

        It "Session should be closed." {
            Close-WinSCPSession -WinSCPSession $session
            $session.Opened | Should Be $null
        }

        Remove-Item -Path $ftp -Confirm:$false -Force -Recurse
        Remove-Item -Path $local -Confirm:$false -Force -Recurse
    }
}