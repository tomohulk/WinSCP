Import-Module -Name "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\WinSCP.psd1"

# Default session options for local machine ftp service.
$sessionOptions = New-WinSCPSessionOptions -HostName 127.0.0.1 -UserName MyUser -Password MyPassword -Protocol Ftp
$ftpDirectory = "C:\FTP"
$localDirectory = "C:\Local"

Describe "Open-WinSCPSession Close-WinSCPSession" {
    Context "Open and Close WinSCP Session." {
        $session = Open-WinSCPSession -SessionOptions $sessionOptions

        It "Result should be of type WinSCP.Session" {
            $session.GetType() | Should Be WinSCP.Session
        }

        It "Session should be open." {
            $session.Opened | Should Be $true
        }

        Close-WinSCPSession -WinSCPSession $session

        It "Session should be closed, using Close-WinSCPSession." {
            $session.Opened | Should Be $null
        }
    }

    Context "Auto dispose WinSCP Session." {
        $session = Open-WinSCPSession -SessionOptions $sessionOptions
                
        It "Result should be of type WinSCP.Session" {
            $session.GetType() | Should Be WinSCP.Session
        }

        It "Session should be open." {
            $session.Opened | Should Be $true
        }
         
        $session | New-WinSCPDirectory -Path "./TestDir"
        Remove-Item -Path "$ftpDirectory\TestDir" -Confirm:$false -Force

        It "Session should be closed, using auto disposal from New-WinSCPDirectory cmdlet." {
            $session.Opened | Should Be $null
        }
    }
}

Describe "Receive-WinSCPItem" {
    $session = Open-WinSCPSession -SessionOptions $sessionOptions

    Context "Receive text document." {
        New-Item -Path "$ftpDirectory\TestFile.txt" -ItemType File -Value "Text text."
        
        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "./TestFile.txt" -LocalPath "$localDirectory\TestFile.txt"

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "File transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "File should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFile.txt" | Should Be $true
        }

        It "File should exist in FTP directory." {
            Test-Path -Path "$localDirectory\TestFile.txt" | Should Be $true
        }

        Remove-Item -Path "$localDirectory\TestFile.txt" -Confirm:$false -Force
        Remove-Item -Path "$ftpDirectory\TestFile.txt" -Confirm:$false -Force
    }

    Context "Receive text document and remove from source." {
        New-Item -Path "$ftpDirectory\TestFile.txt" -ItemType File -Value "Test text."

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "./TestFile.txt" -LocalPath "$localDirectory\TestFile.txt" -Remove

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "File transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "File should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFile.txt" | Should Be $true
        }

        It "File should not exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFile.Txt" | Should Be $false
        }

        Remove-Item -Path "$localDirectory\TestFile.txt" -Confirm:$false -Force
    }

    Context "Receive folder." {
        New-Item -Path "$ftpDirectory\TestFolder" -ItemType Directory

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "/TestFolder" -LocalPath "$localDirectory\TestFolder"

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "Folder transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "Folder should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFolder" | Should Be $true
        }

        It "Folder should exist in FTP directory" {
            Test-Path -Path "$ftpDirectory\TestFolder" | Should Be $true
        }

        Remove-Item -Path "$localDirectory\TestFolder" -Confirm:$false -Force
        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force
    }

    Context "Receive folder and remove from source." {
        New-Item -Path "$ftpDirectory\TestFolder" -ItemType Directory

        $result = Receive-WinSCPItem -WinSCPSession $session -RemotePath "/TestFolder" -LocalPath "$localDirectory\TestFolder" -Remove

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "Folder transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "Folder should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFolder" | Should Be $true
        }

        It "Folder should not exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFolder" | Should Be $false
        }

        Remove-Item -Path "$localDirectory\TestFolder" -Confirm:$false -Force
    }

    Close-WinSCPSession -WinSCPSession $session
}

Describe "Send-WinSCPItem" {
    $sesion = Open-WinSCPSession -SessionOptions $sessionOptions

    Context "Send text document." {
        New-Item -Path "$localDirectory\TestFile.txt" -ItemType File -Value "Test text."

        $result = Send-WinSCPItem -WinSCPSession $sesion -LocalPath "$localDirectory\TestFile.txt" -RemotePath "./"

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "File transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "File should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFile.txt" | Should Be $true
        }

        It "File should exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFile.txt" | Should Be $true
        }

        Remove-Item -Path "$localDirectory\TestFile.txt" -Confirm:$false -Force
        Remove-Item -Path "$ftpDirectory\TestFile.txt" -Confirm:$false -Force
    }

    Context "Send text document and remove from source." {
        New-Item -Path "$localDirectory\TestFile.txt" -ItemType File -Value "Test text."

        $result = Send-WinSCPItem -WinSCPSession $sesion -LocalPath "$localDirectory\TestFile.txt" -RemotePath "./" -Remove

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "File transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "File should not exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFile.txt" | Should Be $false
        }

        It "File should exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFile.txt" | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFile.txt" -Confirm:$false -Force
    }


    Context "Send folder." {
        New-Item -Path "$localDirectory\TestFolder" -ItemType Directory

        $result = Send-WinSCPItem -WinSCPSession $sesion -LocalPath "$localDirectory\TestFolder" -RemotePath "./"

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "Folder transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "Folder should exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFolder" | Should Be $true
        }

        It "Folder should exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFolder" | Should be $true
        }

        Remove-Item -Path "$localDirectory\TestFolder" -Confirm:$false -Force
        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force
    }

    Context "Send folder and remove from source" {
        New-Item -Path "$localDirectory\TestFolder" -ItemType Directory

        $result = Send-WinSCPItem -WinSCPSession $sesion -LocalPath "$localDirectory\TestFolder" -RemotePath "./" -Remove

        It "Result should be of type WinSCP.TransferOperationResult" {
            $result.GetType() | Should Be WinSCP.TransferOperationResult
        }

        It "Folder transfer should be success." {
            $result.IsSuccess | Should Be $true
        }

        It "Folder should not exist in Local directory." {
            Test-Path -Path "$localDirectory\TestFolder" | Should Be $false
        }

        It "Folder should exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFolder" | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force
    }

    Close-WinSCPSession -WinSCPSession $sesion
}

Describe "New-WinSCPDirectory" {
    $session = Open-WinSCPSession -SessionOptions $sessionOptions

    Context "Create new remote direcotry" {
        $result = New-WinSCPDirectory -WinSCPSession $session -Path "./TestFolder"

        It "Result should be of type WinSCP.RemoteFileInfo" {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "Folder should exist in FTP directory." {
            Test-Path -Path "$ftpDirectory\TestFolder" | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force
    }

    Close-WinSCPSession -WinSCPSession $session
}

Describe "Test-WinSCPItemExists" {
    $session = Open-WinSCPSession -SessionOptions $sessionOptions

    Context "Verfiy text document existence." {
        New-Item -Path "$ftpDirectory\TestFile.txt" -ItemType File -Value "Test text."

        $result = Test-WinSCPItemExists -WinSCPSession $session -Path "./TestFile.txt"

        It "File should exist in FTP directory." {
            $result | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFile.txt" -Confirm:$false -Force

        $result = Test-WinSCPItemExists -WinSCPSession $session -Path "./TestFile.txt"

        It "File should not exsit in FTP directory." {
            $result | Should Be $false
        }
    }

    Context "Verfiy folder existence." {
        New-Item -Path "$ftpDirectory\TestFolder" -ItemType Directory

        $result = Test-WinSCPItemExists -WinSCPSession $session -Path "./TestFolder"

        It "Folder should exist in FTP directory." {
            $result | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force

        $result = Test-WinSCPItemExists -WinSCPSession $session -Path "./TestFolder"

        It "Folder should not exist in FTP directory." {
            $result | Should Be $false
        }
    }

    Close-WinSCPSession -WinSCPSession $session
}

Describe "Get-WinSCPItemInformation" {
    $session = Open-WinSCPSession -SessionOptions $sessionOptions

    Context "Verify text document information." {
        New-Item -Path "$ftpDirectory\TestFile.txt" -ItemType File -Value "Test text."

        $result = Get-WinSCPItemInformation -WinSCPSession $session -Path "./TestFile.txt"

        It "Result should be of type WinSCP.RemoteFileInfo" {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "Name property should be /TestFile.txt." {
            $result.Name | Should Be "/TestFile.txt"
        }

        It "IsDirectory property should be false." {
            $result.IsDirectory | Should Be $false
        }

        Remove-Item -Path "$ftpDirectory\TestFile.txt" -Confirm:$false -Force
    }

    Context "Verfy folder information." {
        New-Item -Path "$ftpDirectory\TestFolder" -ItemType Directory

        $result = Get-WinSCPItemInformation -WinSCPSession $session -Path "./TestFolder"

        It "Result should be of type WinSCP.RemoteFileInfo" {
            $result.GetType() | Should Be WinSCP.RemoteFileInfo
        }

        It "Name property should be /TestFolder." {
            $result.Name | Should Be "/TestFolder"
        }

        It "IsDirectory property should be true." {
            $result.IsDirectory | Should Be $true
        }

        Remove-Item -Path "$ftpDirectory\TestFolder" -Confirm:$false -Force
    }

    Close-WinSCPSession -WinSCPSession $session
}