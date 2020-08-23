#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Receive-WinSCPItem" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    
        $credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
        
        $ftp = "$env:SystemDrive\temp\ftproot"
        New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force |
            Out-Null
        New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force |
            Out-Null
        $temp = New-Item "$env:SystemDrive\temp\Receive-WinSCPItem" -ItemType Directory -Force

        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )

    }

    AfterAll {
        Remove-WinSCPSession
        
        Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
        Remove-Item -Path $temp -Force -Recurse -Confirm:$false
    }

    Context "Receive-WinSCPItem -Path `"/TextFile.txt`" -Destination `"$($temp.FullName)`"" {
        BeforeAll {
            $results = Receive-WinSCPItem -Path "/TextFile.txt" -Destination $temp.FullName
        }

        It "Results of Receive-WinSCPItem -Path `"/TextFile.txt`" -Destination `"$($temp.FullName)`" should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of Receive-WinSCPItem -Path `"/TextFile.txt`" -Destination `"$($temp.FullName)`" should be success." {
            $results.IsSuccess |
                Should -Be $true
        }

        It "TextFile.txt should exist in $temp" {
            Test-Path -Path "$($temp.FullName)\TextFile.txt" |
                Should -Be $true
        }
    }

    Context "Receive-WinSCPItem -Path `"/SubDirectory`" -Destination `"$($temp.FullName)`"" {
        BeforeAll {
            $results = Receive-WinSCPItem -Path "/SubDirectory" -Destination $temp.FullName
        }

        It "Results of Receive-WinSCPItem -Path `"/SubDirectory`" -Destination `"$($temp.FullName)`" should not be null." {
            $results |
                Should -Not -Be $null
        }

        It "Results of Receive-WinSCPItem -Path `"/SubDirectory`" -Destination `"$($temp.FullName)`" should be success." {
            $results.IsSuccess |
                Should -Be $true
        }

        It "SubDirectory should exist in $temp." {
            Test-Path -Path "$($temp.FullName)\SubDirectory" |
                Should -Be $true
        }

        It "SubDirectoryTextFile.txt should exist in $temp\SubDirectory." {
            Test-Path -Path "$($temp.FullName)\SubDirectory\SubDirectoryTextFile.txt" |
                Should -Be $true
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Receive-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Receive-WinSCPItem.ps1"
        }

        It "Invoke-ScriptAnalyzer of Receive-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
