#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null

Describe "Get-WinSCPItem" {
    $paths = @(
        "SubDirectory",
        "SubDirectory/",
        "/SubDirectory",
        "/SubDirectory/",
        "./SubDirectory",
        "./SubDirectory/"
    )

    foreach ($path in $paths) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPItem -Path `"$path`"; Remove-WinSCPSession" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Get-WinSCPItem -Path $path
            Remove-WinSCPSession

            It "Results of Get-WinSCPItem should not be null." {
                $results | 
                    Should Not Be Null
            }

            It "Results of Get-WinSCPItem Count should be one." {
                $results.Count | 
                    Should Be 1
            }

            It "WinSCP process should not exist." {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                    Should BeNullOrEmpty
            }
        }
    }

    $files = @(
        "TextFile.txt",
        "TextFile.txt/",
        "/TextFile.txt",
        "/TextFile.txt/",
        "./TextFile.txt",
        "./TextFile.txt/"
    )

    foreach ($file in $files) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPItem -Path `"$file`"; Remove-WinSCPSession" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Get-WinSCPItem -Path $file
            Remove-WinSCPSession

            It "Results of Get-WinSCPItem should not be null." {
                $results | 
                    Should Not Be Null
            }

            It "Results of Get-WinSCPItem Count should be one." {
                $results.Count | 
                    Should Be 1
            }

            It "WinSCP process should not exist." {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                    Should BeNullOrEmpty
            }
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPItem -Path `"/InvalidPath`"; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        Get-WinSCPItem -Path "/InvalidPath" -ErrorVariable e -ErrorAction SilentlyContinue
        Remove-WinSCPSession
        
        It "Results of Get-WinSCPItem should Write-Error." {            
            $e | 
                Should Not BeNullOrEmpty
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer results count for Get-WinSCPItem.ps1 should be 0." {
            $results.Count | 
                Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
