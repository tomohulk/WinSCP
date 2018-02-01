#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null

Describe "Get-WinSCPChildItem" {
    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPChildItem; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = Get-WinSCPChildItem
        Remove-WinSCPSession

        It "Results of Get-WinSCPChildItem should not be null." {
            $results | 
                Should Not Be Null
        }

        It "Results of Get-WinSCPChildItem Count should be two." {
            $results.Count | 
                Should Be 2
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPChildItem -Recurse; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = Get-WinSCPChildItem -Recurse
        Remove-WinSCPSession

        It "Results of Get-WinSCPChildItem should not be null." {
            $results | 
                Should Not Be Null
        }

        It "Results of Get-WinSCPChildItem Count should be three." {
            $results.Count | 
                Should Be 3
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPChildItem -Recurse -Filter `"*.txt`"; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        $results = Get-WinSCPChildItem -Recurse -Filter "*.txt"
        Remove-WinSCPSession

        It "Results of Get-WinSCPChildItem should not be null." {
            $results | 
                Should Not Be Null
        }

        It "Results of Get-WinSCPChildItem Count should be two." {
            $results.Count | 
                Should Be 2
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    $paths = @(
        ".",
        "/",
        "./"
    )

    foreach ($path in $paths) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPChildItem -Path `"$path`"; Remove-WinSCPSession" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Get-WinSCPChildItem -Path $path
            Remove-WinSCPSession

            It "Results of Get-WinSCPChildItem should not be null." {
                $results | 
                    Should Not Be Null
            }

            It "Results of Get-WinSCPChildItem Count should be two." {
                $results.Count | 
                    Should Be 2
            }

            It "WinSCP process should not exist." {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                    Should BeNullOrEmpty
            }
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Get-WinSCPChildItem -Path `"/InvalidPath`"; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp ) 
        Get-WinSCPChildItem -Path "/InvalidPath" -ErrorVariable e -ErrorAction SilentlyContinue
        Remove-WinSCPSession

        It "Results of Get-WinSCPChildItem should Write-Error." {
            $e | 
                Should Not BeNullOrEmpty
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPChildItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Get-WinSCPChildItem.ps1"

        It "Invoke-ScriptAnalyzer of Get-WinSCPChildItem results count should be 0." {
            $results.Count | 
                Should Be 0
        }
    }
}

Remove-Item -Path ( Join-Path -Path $ftp -ChildPath * ) -Recurse -Force -Confirm:$false
