#requires -Modules Pester, PSScriptAnalyzer, WinSCP

Describe "Send-WinSCPItem" {
    BeforeAll {
        Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
            Stop-Process -Force
    
        $credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
        
        $ftp = "$env:SystemDrive\temp\ftproot"
        $temp = New-Item "$env:SystemDrive\temp\Send-WinSCPItem" -ItemType Directory -Force
        New-Item -Path "$temp\TextFile.txt" -ItemType File -Value "Hello World!" -Force |
            Out-Null
        New-Item -Path "$temp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hellow World!" -Force |
            Out-Null

        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
    }

    AfterAll {
        Remove-WinSCPSession

        Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
        Remove-Item -Path $temp -Force -Recurse -Confirm:$false
    }

    Context "Send-WinSCPItem -Path `"$temp\TextFile.txt`" -Destination `"<Destination>`"" {
        AfterEach {
            Remove-Item -Path "$ftp\*" -Force -Recurse
        }
        
        $testCases = @(
            @{ Destination = "TextFile.txt" }
            @{ Destination = "TextFile.txt/" }
            @{ Destination = "/TextFile.txt" }
            @{ Destination = "/TextFile.txt/" }
            @{ Destination = "./TextFile.txt" }
            @{ Destination = "./TextFile.txt/" }
        )

        It "Result of Send-WinSCPItem -Path `"$temp\TextFile.txt`" -Destination `"<Destination>`" should be succsessful." -TestCases $testCases {
            param (
                [String]
                $Destination
            )
            (Send-WinSCPItem -Path "$temp\TextFile.txt" -Destination $Destination).IsSuccess |
                Should -Be $true
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Send-WinSCPItem.ps1`"" {
        BeforeAll {
            $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Send-WinSCPItem.ps1"
        }

        It "Invoke-ScriptAnalyzer of Send-WinSCPItem results count should be 0." {
            $results.Count |
                Should -Be 0
        }
    }
}
