#requires -Modules Pester, PSScriptAnalyzer

if (Get-Module | Where-Object { $_.Name -eq 'WinSCP' })
{
    Remove-Module -Name WinSCP
}

Set-Location -Path "$env:USERPROFILE\Documents\GitHub\WinSCP"
Import-Module -Name .\WinSCP.psd1


Describe 'New-WinSCPSession' {
    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp" {
        $session = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp

        It 'Session should be of type WinSCP.Session.' {
            $session.GetType() | Should Be WinSCP.Session
        }

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        It "Hostname should be $env:COMPUTERNAME." {
            $session
        }

        It 'Session should be closed and the object should be disposed.' {
            Remove-WinSCPSession -WinSCPSession $session
            $session | Should Not Exist
        }
    }

    Context "New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp -SessionLogPath $env:TEMP\Session.log -DebugLogPath $env:TEMP\Debug.log" {
        $session = New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp -SessionLogPath "$env:TEMP\Session.log" -DebugLogPath "$env:TEMP\Debug.log"

        It 'Session should be of type WinSCP.Session.' {
            $session.GetType() | Should Be WinSCP.Session
        }

        It 'Session should be open.' {
            $session.Opened | Should Be $true
        }

        It "$env:TEMP\Session.log should exist." {
            Test-Path -Path "$env:TEMP\Session.log" | Should Be $true
        }

        It "$env:TEMP\Debug.log should exist." {
            Test-Path -Path "$env:TEMP\Debug.log" | Should Be $true
        }

        It 'Session should be closed and the object should be disposed.' {
            Remove-WinSCPSession -WinSCPSession $session
            $session | Should Not Exist
        }

        Remove-Item -Path @("$env:TEMP\Session.log", "$env:TEMP\Debug.log") -Force -Confirm:$false
    }

    Context "Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path (Get-Location))\Functions\New-WinSCPSession.ps1." {
        $results = Invoke-ScriptAnalyzer -Path .\Functions\New-WinSCPSession.ps1

        it 'Invoke-ScriptAnalyzer results of New-WinSCPSession count should be 0.' {
            $results.Count | Should Be 0
        }
    }
}

Remove-Module -Name WinSCP