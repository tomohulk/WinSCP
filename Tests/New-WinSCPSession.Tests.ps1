#Requires -Modules Pester, PSScriptAnalyzer, WinSCP

Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
    Stop-Process -Force

$credential = ( New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "filezilla", ( ConvertTo-SecureString -AsPlainText "filezilla" -Force ))

Describe "New-WinSCPSession" {
    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp )" {
        $session = New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp )

        It "Session should be open." {
            $session.Opened |
                Should Be $true
        }

        It "Hostname should be $env:COMPUTERNAME." {
            $session.Hostname |
                Should Be $env:COMPUTERNAME
        }

        Remove-WinSCPSession -WinSCPSession $session
        It "Session should be closed and the object should be disposed." {
            $session |
                Should Not Exist
        }
    }

    Context "New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential `$credential -HostName $env:COMPUTERNAME -Protocol Ftp ) -SessionLogPath $env:TEMP\Session.log -DebugLogPath $env:TEMP\Debug.log" {
        $session = New-WinSCPSession -SessionOption ( New-WinSCPSessionOption -Credential $credential -HostName $env:COMPUTERNAME -Protocol Ftp ) -SessionLogPath "$env:TEMP\Session.log" -DebugLogPath "$env:TEMP\Debug.log"

        It "Session should be open." {
            $session.Opened |
                Should Be $true
        }

        It "$env:TEMP\Session.log should exist." {
            Test-Path -Path "$env:TEMP\Session.log" |
                Should Be $true
        }

        It "$env:TEMP\Debug.log should exist." {
            Test-Path -Path "$env:TEMP\Debug.log" |
                Should Be $true
        }

        Remove-WinSCPSession -WinSCPSession $session
        It "Session should be closed and the object should be disposed." {
            $session |
                Should Not Exist
        }

        Remove-Item -Path @("$env:TEMP\Session.log", "$env:TEMP\Debug.log") -Force -Confirm:$false
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPSession.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\New-WinSCPSession.ps1"

        It "Invoke-ScriptAnalyzer of New-WinSCPItem results count should be 0." {
            $results.Count |
                Should Be 0
        }
    }
}
