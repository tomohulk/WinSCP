#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "New-WinSCPItem" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    
        $credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
        $ftp = "$env:SystemDrive\temp\ftproot"

        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
    }

    AfterAll {
        Remove-WinSCPSession

        Remove-Item -Path ( Join-Path -Path $ftp -ChildPath * ) -Recurse -Force -Confirm:$false
    }
    
    Context "New-WinSCPItem -Path `"TestFolder`" -ItemType Directory" {
        BeforeAll {
            $results = New-WinSCPItem -Name "TestFolder" -ItemType Directory
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -ItemType Directory should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -ItemType Directory should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"TestFolder`" -ItemType Directory -Force" {
        BeforeAll {
            $results = New-WinSCPItem -Name "TestFolder" -ItemType Directory -Force
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -ItemType Directory -Force should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -ItemType Directory -Force should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"Test.txt`" -ItemType File" {
        BeforeAll {
            $results = New-WinSCPItem -Name "Test.txt" -ItemType File
        }

        It "Results of New-WinSCPItem -Path `"Test.txt`" -ItemType File should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"Test.txt`" -ItemType File should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"Test.txt`" -ItemType File -Force"  {
        BeforeAll {
            $results = New-WinSCPItem -Name "Test.txt" -ItemType File -Force
        }

        It "Results of New-WinSCPItem -Path `"Test.txt`" -ItemType File -Force should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"Test.txt`" -ItemType File -Force should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory" {
        BeforeAll {
            $results = New-WinSCPItem -Path "TestFolder" -Name "TestFolder" -ItemType Directory
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory -Force" {
        BeforeAll {
            $results = New-WinSCPItem -Path "TestFolder" -Name "TestFolder" -ItemType Directory -Force
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory -Force should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name TestFolder -ItemType Directory -Force should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File" {
        BeforeAll {
            $results = New-WinSCPItem -Path "TestFolder" -Name "Test.txt" -ItemType File
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File -Force" {
        BeforeAll {
            $results = New-WinSCPItem -Path "TestFolder" -Name "Test.txt" -ItemType File -Force
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File -Force should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of New-WinSCPItem -Path `"TestFolder`" -Name `"Test.txt`" -ItemType File -Force should be of type WinSCP.RemoteFileInfo." {
            $results |
                Should -BeOfType WinSCP.RemoteFileInfo
        }

        It "RemoteFileInfo should contain a FullName property that is not null." {
            $results.FullName |
                Should -Not -Be $null
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPItem.ps1"
        }

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
