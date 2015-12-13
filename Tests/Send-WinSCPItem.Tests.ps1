#requires -Modules Pester,PSScriptAnalyzer

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP\WinSCP.psd1 -Force

Get-Process | Where-Object { $_.Name -eq 'WinSCP' } | Stop-Process -Force

$ftp = "$pwd\Tests\Ftp"
New-Item -Path $ftp -ItemType Directory -Force | Out-Null

$local = "$pwd\Tests\Local"
New-Item -Path "$local\TextFile.txt" -ItemType File -Value 'Hello World!' -Force | Out-Null
New-Item -Path "$local\SubDirectory\SubDirectoryTextFile.txt" -ItemType File -Value 'Hellow World!' -Force | Out-Null

Describe 'Send-WinSCPItem' {
    $credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString))

    $paths = @(
        'TextFile.txt',
        'TextFile.txt',
        '/TextFile.txt',
        '/TextFile.txt/',
        './TextFile.txt',
        './TextFile.txt/'
    )

    foreach ($path in $paths) {
        Context "`New-WinSCPSession -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '$path'" {
            $results = New-WinSCPSession -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp | Send-WinSCPItem -Path "$local\TextFile.txt" -Destination $path

            It 'Transfer should be succsessful.' {
                $results.IsSuccess | Should Be $true
            }

            Remove-Item -Path "$ftp\*" -Force -Recurse
        }
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\Send-WinSCPItem.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\WinSCP\Public\Send-WinSCPItem.ps1

        It 'Invoke-ScriptAnalyzer of Send-WinSCPItem results count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Item -Path $ftp -Recurse -Force -Confirm:$false
Remove-Item -Path $local -Recurse -Force -Confirm:$false
Remove-Module -Name WinSCP -Force