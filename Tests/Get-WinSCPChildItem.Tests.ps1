#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Get-WinSCPChildItem" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
            Stop-Process -Force
    
        $credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
        
        $ftp = "$env:SystemDrive\temp\ftproot"
        New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force | 
            Out-Null
        New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force | 
            Out-Null

        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
    }

    AfterAll {
        Remove-WinSCPSession
        
        Remove-Item -Path ( Join-Path -Path $ftp -ChildPath * ) -Recurse -Force -Confirm:$false
    }

    Context "Get-WinSCPChildItem" {
        BeforeAll {
            $results = Get-WinSCPChildItem
        }

        It "Results of Get-WinSCPChildItem should not be null." {
            $results | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPChildItem Count should be two." {
            $results.Count | 
                Should -Be 2
        }
    }

    Context "Get-WinSCPChildItem -Recurse" {
        BeforeAll {
            $results = Get-WinSCPChildItem -Recurse
        }

        It "Results of Get-WinSCPChildItem -Recurse should not be null." {
            $results | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPChildItem -Recurse Count should be three." {
            $results.Count | 
                Should -Be 3
        }
    }

    Context "Get-WinSCPChildItem -Recurse -Filter `"*.txt`"" {
        BeforeAll {
            $results = Get-WinSCPChildItem -Recurse -Filter "*.txt"
        }

        It "Results of Get-WinSCPChildItem -Recurse -Filter `"*.txt`" should not be null." {
            $results | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPChildItem -Recurse -Filter `"*.txt`" Count should be two." {
            $results.Count | 
                Should -Be 2
        }
    }

    Context "Get-WinSCPChildItem -Path `"<Path>`"" {
        $testCases = @(
            @{ Path = "." }
            @{ Path = "/" }
            @{ Path = "." }
        )

        It "Results of Get-WinSCPChildItem -Path <Path> should not be null." -TestCases $testCases {
            Param(
                [String]$Path
            )

            Get-WinSCPChildItem -Path $Path | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPChildItem -Path <Path> Count should be two." -TestCases $testCases {
            Param (
                [String]$Path
            )

            ( Get-WinSCPChildItem -Path $Path ).Count | 
                Should -Be 2
        }
    }

    Context "Get-WinSCPChildItem -Path `"/InvalidPath`"" {
        BeforeAll {
            Get-WinSCPChildItem -Path "/InvalidPath" -ErrorVariable e -ErrorAction SilentlyContinue
        }

        It "Results of Get-WinSCPChildItem -Path `"/InvalidPath`" should Write-Error." {
            $e | 
                Should -Not -BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPChildItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPChildItem.ps1"
        }

        It "Invoke-ScriptAnalyzer of Get-WinSCPChildItem results count should be 0." {
            $results.Count | 
                Should -Be 0
        }
    }
}
