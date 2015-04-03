Param ($server,$username,$password)

Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe 'Send-WinSCPItem' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should be $true
    }

        $params = @{
        HostName = $server
        UserName = $username
        Password = $password
        Protocol = 'Ftp'
    }

    Context "Send-WinSCPItem -WinSCPSession `$session -LocalPath `"$(Get-Location)\Local\Folder`" -RemotePath `"./`"" {
        $ftp = New-Item -Path "$(Get-Location)\Ftp" -ItemType Directory
        $local = New-Item -Path "$(Get-Location)\Local" -ItemType Directory
        $folder = New-Item -Path "$local\Folder" -ItemType Directory

        It "$($ftp.FullName), $($local.FullName) and $($folder.FullName) should exist." {
            Test-Path -Path $ftp | Should Be $true
            Test-Path -Path $local | Should Be $true
            Test-Path -Path $folder | Should Be $true
        }

        $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions @params)

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        $result = Send-WinSCPItem -WinSCPSession $session -LocalPath "$(Get-Location)\Local\Folder" -RemotePath './'

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
}