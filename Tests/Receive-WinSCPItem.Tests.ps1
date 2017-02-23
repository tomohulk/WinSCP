#requires -Modules Pester,PSScriptAnalyzer

Import-Module -Name .\WinSCP\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

$ftp = "$env:SystemDrive\temp\ftproot"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
$temp = New-Item "$pwd\Tests\Temp" -ItemType Directory -Force

Describe 'Receive-WinSCPItem' {
    $credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'filezilla', (ConvertTo-SecureString -AsPlainText 'filezilla' -Force))

    Context "New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/TextFile.txt -Destination $($temp.FullName)" {
        $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/TextFile.txt' -Destination $temp.FullName

        It 'Results of Get-WinSCPItem should not be null.' {
            $results | Should Not Be Null
        }

        It 'Results of transfer should be success.' {
            $results.IsSuccess | Should Be $true
        }

        It "TextFile.txt should exist in $temp" {
            Test-Path -Path "$($temp.FullName)\TextFile.txt" | Should Be $true
        }

        It 'WinSCP process should not exist.' {
            Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Receive-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Receive-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Receive-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
Remove-Item -Path (Join-Path -Path $temp -ChildPath *)-Recurse -Force -Confirm:$false
