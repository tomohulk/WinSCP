Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "New-WinSCPSessionOptions" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }

    Context "New-WinSCPSessionOptions -HostName $env:COMPUTERNAME -UserName 'MyUser' -Password 'MyPassword' -Protocal Ftp" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = 'MyUser'
            Password = 'MyPassword'
            Protocol = 'Ftp'
        }
        
        $sessionOptions = New-WinSCPSessionOptions @params

        It "Should be of type WinSCP.SessionOptions." {
            $sessionOptions.GetType() | Should Be WinSCP.SessionOptions
        }

        It "Protocal should be 'Ftp' and of Type WinSCP.Protocol." {
            $sessionOptions.Protocol | Should Be 'Ftp'
            $sessionOptions.Protocol.GetType() | Should Be WinSCP.Protocol
        }

        It "HostName should be '$env:COMPUTERNAME' and of Type String." {
            $sessionOptions.HostName | Should Be $env:COMPUTERNAME
            $sessionOptions.HostName.GetType() | Should Be String
        }

        It "PortNumber should be 0 and of Type Int." {
            $sessionOptions.PortNumber | Should Be 0
            $sessionOptions.PortNumber.GetType() | Should Be Int
        }

        It "UserName should be 'MyUser' and of Type String." {
            $sessionOptions.UserName | Should Be 'MyUser'
            $sessionOptions.UserName.GetType() | Should Be String
        }

        It "Password should be 'MyPassword' and of Type String." {
            $sessionOptions.Password | Should Be 'MyPassword'
            $sessionOptions.Password.GetType() | Should Be String
        }

        It "SecurePassword should be of Type SecureString." {
            $sessionOptions.SecurePassword.GetType() | Should Be SecureString
        }

        It "Timeout should be 15 seconds and of Type TimeSpan." {
            $sessionOptions.Timeout.Seconds | Should Be 15
            $sessionOptions.Timeout.GetType() | Should Be TimeSpan
        }

        It "SshHostKeyFingerprint should be null." {
            $sessionOptions.SshHostKeyFingerprint | Should Be $null
        }

        It "GiveUpSecurityAndAcceptAnySshHostKey should be false." {
            $sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey | Should Not Be $true
        }

        It "SshPrivateKeyPath should be null." {
            $sessionOptions.SshPrivateKeyPath | Should Be $null
        }

        It "SshPrivateKeyPassphrase should be null." {
            $sessionOptions.SshPriaveKeyPassphrase | Should Be $null
        }

        It "FtpMode should be 'Passive' and of type WinSCP.FtpMode." {
            $sessionOptions.FtpMode | Should Be Passive
            $sessionOptions.FtpMode.GetType() | Should Be WinSCP.FtpMode
        }

        It "FtpSecure should be 'None' and of type WinSCP.FtpSecure." {
            $sessionOptions.FtpSecure | Should Be None
            $sessionOptions.FtpSecure.GetType() | Should be WinSCP.FtpSecure
        }

        It "WebdavSecure should be false." {
            $sessionOptions.WebdavSecure | Should Not Be $true
        }

        It "WebdavRoot should be null." {
            $sessionOptions.WebdavRoot | Should be $null
        }

        It "TlsHostCertificateFingerprint should be null." {
            $sessionOptions.TlsHostCertificateFingerprint | Should Be $null
        }

        It "GiveUpSecurityAndAcceptAnyTlsHostCertificate should be false." {
            $sessionOptions.GiveUpSecurityAndAcceptAnyTlsHostCertificate | Should Not Be $true
        }
    }

    Context "New-WinSCPSessionOptions -HostName $env:COMPUTERNAME -UserName 'MyUser' -Password 'MyPassword' -Protocal Sftp -SshHostKeyFingerprint 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa'" {
        $params = @{
            HostName = $env:COMPUTERNAME
            UserName = 'MyUser'
            Password = 'MyPassword'
            Protocol = 'Sftp'
            SshHostKeyFingerprint = 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa'
        }
        
        $sessionOptions = New-WinSCPSessionOptions @params

        It "Should be of type WinSCP.SessionOptions." {
            $sessionOptions.GetType() | Should Be WinSCP.SessionOptions
        }

        It "Protocal should be 'Sftp' and of Type WinSCP.Protocol." {
            $sessionOptions.Protocol | Should Be 'Sftp'
            $sessionOptions.Protocol.GetType() | Should Be WinSCP.Protocol
        }

        It "HostName should be '$env:COMPUTERNAME' and of Type String." {
            $sessionOptions.HostName | Should Be $env:COMPUTERNAME
            $sessionOptions.HostName.GetType() | Should Be String
        }

        It "PortNumber should be 0 and of Type Int." {
            $sessionOptions.PortNumber | Should Be 0
            $sessionOptions.PortNumber.GetType() | Should Be Int
        }

        It "UserName should be 'MyUser' and of Type String." {
            $sessionOptions.UserName | Should Be 'MyUser'
            $sessionOptions.UserName.GetType() | Should Be String
        }

        It "Password should be 'MyPassword' and of Type String." {
            $sessionOptions.Password | Should Be 'MyPassword'
            $sessionOptions.Password.GetType() | Should Be String
        }

        It "SecurePassword should be of Type SecureString." {
            $sessionOptions.SecurePassword.GetType() | Should Be SecureString
        }

        It "Timeout should be 15 seconds and of Type TimeSpan." {
            $sessionOptions.Timeout.Seconds | Should Be 15
            $sessionOptions.Timeout.GetType() | Should Be TimeSpan
        }

        It "SshHostKeyFingerprint should be 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa' and of Type String." {
            $sessionOptions.SshHostKeyFingerprint | Should Be 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa'
            $sessionOptions.SshHostKeyFingerprint.GetType() | Should Be String
        }

        It "GiveUpSecurityAndAcceptAnySshHostKey should be false." {
            $sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey | Should Not Be $true
        }

        It "SshPrivateKeyPath should be null." {
            $sessionOptions.SshPrivateKeyPath | Should Be $null
        }

        It "SshPrivateKeyPassphrase should be null." {
            $sessionOptions.SshPriaveKeyPassphrase | Should Be $null
        }

        It "FtpMode should be 'Passive' and of type WinSCP.FtpMode." {
            $sessionOptions.FtpMode | Should Be Passive
            $sessionOptions.FtpMode.GetType() | Should Be WinSCP.FtpMode
        }

        It "FtpSecure should be 'None' and of type WinSCP.FtpSecure." {
            $sessionOptions.FtpSecure | Should Be None
            $sessionOptions.FtpSecure.GetType() | Should be WinSCP.FtpSecure
        }

        It "WebdavSecure should be false." {
            $sessionOptions.WebdavSecure | Should Not Be $true
        }

        It "WebdavRoot should be null." {
            $sessionOptions.WebdavRoot | Should be $null
        }

        It "TlsHostCertificateFingerprint should be null." {
            $sessionOptions.TlsHostCertificateFingerprint | Should Be $null
        }

        It "GiveUpSecurityAndAcceptAnyTlsHostCertificate should be false." {
            $sessionOptions.GiveUpSecurityAndAcceptAnyTlsHostCertificate | Should Not Be $true
        }
    }
}