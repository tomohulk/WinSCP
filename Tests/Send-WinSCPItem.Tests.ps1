#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"

$temp = New-Item "$env:SystemDrive\temp\Send-WinSCPItem" -ItemType Directory -Force
New-Item -Path "$temp\TextFile.txt" -ItemType File -Value "Hello World!" -Force |
    Out-Null
New-Item -Path "$Temp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hellow World!" -Force |
    Out-Null

Describe "Send-WinSCPItem" {
    $paths = @(
        "TextFile.txt",
        "TextFile.txt",
        "/TextFile.txt",
        "/TextFile.txt/",
        "./TextFile.txt",
        "./TextFile.txt/"
    )

    foreach ($path in $paths) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Send-WinSCPItem -Path `"$temp\TextFile.txt`" -Destination `"$path`"" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Send-WinSCPItem -Path "$temp\TextFile.txt" -Destination $path
            Remove-WinSCPSEssion

            It "Transfer should be succsessful." {
                $results.IsSuccess |
                    Should Be $true
            }

            Remove-Item -Path "$ftp\*" -Force -Recurse
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Send-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Send-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
Remove-Item -Path $temp -Force -Recurse -Confirm:$false
