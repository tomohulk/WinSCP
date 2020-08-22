#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Move-WinSCPItem" {
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

        Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
    }

    Context "Move-WinSCPItem -Path `"/TextFile.txt`" -Destination `"<Path>`"" {
        $testCases = @(
            @{ Destination = "SubDirectory" }
            @{ Destination = "SubDirectory/" }
            @{ Destination = "/SubDirectory" }
            @{ Destination = "/SubDirectory/" }
            @{ Destination = "./SubDirectory" }
            @{ Destination = "./SubDirectory/" }
        )

        It "Results of Move-WinSCPItem -Path `"/TextFile.txt`" -Destination `"<Destination>`" should be null, -PassThru switch not used." -TestCases $testCases {
            Param (
                [String]$Destination
            )
            
            # Return the TestFile.txt to the root directory to continue testing other formats.
            if (Test-Path -Path "$ftp\SubDirectory\TextFile.txt") {
                Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
            }

            Move-WinSCPItem -Path "TextFile.txt" -Destination $Destination |
                Should -BeNullOrEmpty
        }

        It "Results of Test-Path -Path `"${ftp}\TextFile.txt`" should be false." {
            Test-Path -Path "${ftp}\TextFile.txt" |
                Should -Be $false
        }

        It "Results of Test-WinPath -Path `"${ftp}\SubDirectory\TextFile.txt`" should be true" -TestCases $testCases {
            Test-Path -Path "$ftp\SubDirectory\TextFile.txt" |
                Should -Be $true
        }
    }

    Context "Move-WinSCPItem -Path `"<Path>`" -Destination `"./SubDirectory`"" {
        $testCases = @(
            @{ Path = "TextFile.txt" }
            @{ Path = "/TextFile.txt" }
            @{ Path = "./TextFile.txt" }
        )

        It "Results of Move-WinSCPItem -Path `"<Path>`" -Destination `"./SubDirectory`" should be null, -PassThru switch not used." -TestCases $testCases {
            Param (
                [String]$Path
            )

            # Return the TestFile.txt to the root directory to continue testing other formats.
            if (Test-Path -Path "$ftp\SubDirectory\TextFile.txt") {
                Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
            }

            Move-WinSCPItem -Path $Path -Destination "./SubDirectory" |
                Should -BeNullOrEmpty
        }

        It "Results of Test-Path -Path `"${ftp}\TextFile.txt`" should be false." {
            Test-Path -Path "$ftp\TextFile.txt" |
                Should -Be $false
        }

        It "Results of Test-WinSCP -Path `"./SubDirectory/TextFile.txt`" should be true." {
            Test-WinSCPPath -Path "./SubDirectory/TextFile.txt" |
                Should -Be $true
        }
    }

    Context "Move-WinSCPItem -Path `"/TextFile.txt`" -Destination `"/InvalidSubDirectory`"" {
        BeforeAll {
            Move-WinSCPItem -Path "/TextFile.txt" -Destination "/InvalidSubDirectory" -ErrorVariable e -ErrorAction SilentlyContinue
        }

        It "Results of Move-WinSCPItem should Write-Error." {
            $e |
                Should -Not -BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Move-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Move-WinSCPItem.ps1"
        }

        It "Invoke-ScriptAnalyzer of Move-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
