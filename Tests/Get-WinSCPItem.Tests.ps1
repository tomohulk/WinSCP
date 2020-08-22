#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Get-WinSCPItem" {
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

    Context "Get-WinSCPItem -Path `"<Path>`"" {
        $testCases = @(
            @{ Path = "SubDirectory" }
            @{ Path = "SubDirectory/" }
            @{ Path = "/SubDirectory" }
            @{ Path = "/SubDirectory/" }
            @{ Path = "./SubDirectory" }
            @{ Path = "./SubDirectory/" }
        )

        It "Results of Get-WinSCPItem -Path `"<Path>`" should not be null." -TestCases $testCases {
            Param (
                [String]$Path
            )

            Get-WinSCPItem -Path $Path | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPItem -Path `"<Path>`" Count should be one." -TestCases $testCases {
            Param (
                [String]$Path
            )
            
            ( Get-WinSCPItem -Path $Path ).Count | 
                Should -Be 1
        }
    }

    Context "Get-WinSCPItem -Path `"<Path>`"" {
        $testCases = @(
            @{ Path = "TextFile.txt" }
            @{ Path = "TextFile.txt/" }
            @{ Path = "/TextFile.txt" }
            @{ Path = "/TextFile.txt/" }
            @{ Path = "./TextFile.txt" }
            @{ Path = "./TextFile.txt/" }
        )

        It "Results of Get-WinSCPItem -Path `"<Path>`" should not be null." -TestCases $testCases {
            Param (
                [String]$Path
            )

            Get-WinSCPItem -Path $Path | 
                Should -Not -Be $null
        }

        It "Results of Get-WinSCPItem -Path `"<Path>`" Count should be one." -TestCases $testCases {
            ( Get-WinSCPItem -Path $Path ).Count | 
                Should -Be 1
        }
    }

    Context "Get-WinSCPItem -Path `"/InvalidPath`"" {
        BeforeAll {
            Get-WinSCPItem -Path "/InvalidPath" -ErrorVariable e -ErrorAction SilentlyContinue
        }
        
        It "Results of Get-WinSCPItem -Path `"/InvalidPath`" should Write-Error." {            
            $e | 
                Should -Not -BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPItem.ps1"
        }

        It "Invoke-ScriptAnalyzer results count for Get-WinSCPItem.ps1 should be 0." {
            $results.Count | 
                Should -Be 0
        }
    }
}
