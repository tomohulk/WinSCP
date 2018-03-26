#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force |
    Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force |
    Out-Null
$temp = New-Item "$env:SystemDrive\temp\Receive-WinSCPItem" -ItemType Directory -Force

Describe "Receive-WinSCPItem" {
    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Receive-WinSCPItem -Path `"/TextFile.txt`" -Destination `"$($temp.FullName)`"; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = Receive-WinSCPItem -Path "/TextFile.txt" -Destination $temp.FullName
        Remove-WinSCPSession

        It "Results of Get-WinSCPItem should not be null." {
            $results |
                Should Not Be Null
        }

        It "Results of transfer should be success." {
            $results.IsSuccess |
                Should Be $true
        }

        It "TextFile.txt should exist in $temp" {
            Test-Path -Path "$($temp.FullName)\TextFile.txt" |
                Should Be $true
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Receive-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Receive-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
Remove-Item -Path $temp -Force -Recurse -Confirm:$false
