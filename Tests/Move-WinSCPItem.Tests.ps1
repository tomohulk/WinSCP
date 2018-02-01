#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))
$ftp = "$env:SystemDrive\temp\ftproot"
New-Item -Path "$ftp\TextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null
New-Item -Path "$ftp\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value "Hello World!" -Force | 
    Out-Null

Describe "Move-WinSCPItem" {
    $destinations = @(
        "SubDirectory",
        "SubDirectory/"
        "/SubDirectory",
        "/SubDirectory/",
        "./SubDirectory",
        "./SubDirectory/"
    )
    
    foreach ($destination in $destinations) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Move-WinSCPItem -Path `"/TextFile.txt`" -Destination `"$destination`"; Remove-WinSCPSession" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Move-WinSCPItem -Path "/TextFile.txt" -Destination $destination
            Remove-WinSCPSession

            It "Results of Move-WinSCPItem should be null, -PassThru switch not used." {
                $results | 
                    Should BeNullOrEmpty
            }

            It "TextFile.txt should not exist in root." {
                Test-Path -Path "$ftp\TextFile.txt" | 
                    Should Be $false
            }

            It "TextFile.txt should exsist in /root/SubDirectory" {
                Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | 
                    Should Be $true
            }

            It "WinSCP process should not exist." {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                    Should BeNullOrEmpty
            }

            Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
        }
    }

    $files = @(
        "TextFile.txt",
        "TextFile.txt/"
        "/TextFile.txt",
        "/TextFile.txt/",
        "./TextFile.txt",
        "./TextFile.txt/"
    )

    foreach ($file in $files) {
        Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Move-WinSCPItem -Path `"$file`" -Destination `"./SubDirectory`"; Remove-WinSCPSession" {
            New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
            $results = Move-WinSCPItem -Path $file -Destination "./SubDirectory"
            Remove-WinSCPSession

            It "Results of Move-WinSCPItem should be null, -PassThru switch not used." {
                $results | 
                    Should BeNullOrEmpty
            }

            It "TextFile.txt should not exist in root." {
                Test-Path -Path "$ftp\TextFile.txt" | 
                    Should Be $false
            }

            It "TextFile.txt should exsist in /root/SubDirectory" {
                Test-Path -Path "$ftp\SubDirectory\TextFile.txt" | 
                    Should Be $true
            }

            It "WinSCP process should not exist." {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                    Should BeNullOrEmpty
            }

            Move-Item -Path "$ftp\SubDirectory\TextFile.txt" -Destination $ftp
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ); Move-WinSCPItem -Path `"/TextFile.txt`" -Destination `"/InvalidSubDirectory`"; Remove-WinSCPSession" {
        New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )
        Move-WinSCPItem -Path "/TextFile.txt" -Destination "/InvalidSubDirectory" -ErrorVariable e -ErrorAction SilentlyContinue
        Remove-WinSCPSession

        It "Results of Move-WinSCPItem should Write-Error." {
            $e | 
                Should Not BeNullOrEmpty
        }

        It "WinSCP process should not exist." {
            Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
                Should BeNullOrEmpty
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\Move-WinSCPItem.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\Move-WinSCPItem.ps1"

        It "Invoke-ScriptAnalyzer of Move-WinSCPItem results count should be 0." {
            $results.Count | 
                Should Be 0
        }
    }
}

Remove-Item -Path (Join-Path -Path $ftp -ChildPath *) -Recurse -Force -Confirm:$false
