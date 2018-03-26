#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"

Describe "New-WinSCPItem" {
    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -ItemType Directory; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Name "TestFolder" -ItemType Directory
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -ItemType Directory -Force; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Name "TestFolder" -ItemType Directory -Force
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"Test.txt`" -ItemType File; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Name "Test.txt" -ItemType File
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"Test.txt`" -ItemType File -Force; Remove-WinSCPSession"  {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Name "Test.txt" -ItemType File -Force
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Path "TestFolder" -Name "TestFolder" -ItemType Directory
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory -Force; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Path "TestFolder" -Name "TestFolder" -ItemType Directory -Force
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Path "TestFolder" -Name "Test.txt" -ItemType File
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File -Force; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = New-WinSCPItem -Path "TestFolder" -Name "Test.txt" -ItemType File -Force
        Remove-WinSCPSession

        It "Results of New-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a fullpath property that is not null." {
            $results.FullPath |
                Should Not Be Null
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
