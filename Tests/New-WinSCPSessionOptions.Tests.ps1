Param ($server,$username,$password)


Describe 'New-WinSCPSessionOptions' {
    It 'WinSCP Module should be loaded.' {
        Get-Module -Name WinSCP | Should Be $true
        (Get-Module -Name WinSCP).Path | Should Be "$($env:USERPROFILE)\Documents\GitHub\WinSCP\WinSCP.psm1"
    }

    Context "New-WinSCPSessionOptions -HostName $server -UserName $username -Password $password -Protocal Ftp" {
        $params = @{
            HostName = $server
            UserName = $username
            Password = $password
            Protocol = 'Ftp'
        }
        
        $sessionOptions = New-WinSCPSessionOptions @params

        It 'Should be of type WinSCP.SessionOptions.' {
            $sessionOptions.GetType() | Should Be WinSCP.SessionOptions
        }

        It 'Protocal should be Ftp and of Type WinSCP.Protocol.' {
            $sessionOptions.Protocol | Should Be Ftp
            $sessionOptions.Protocol.GetType() | Should Be WinSCP.Protocol
        }

        It "HostName should be $server and of Type String." {
            $sessionOptions.HostName | Should Be $server
            $sessionOptions.HostName.GetType() | Should Be String
        }

        It 'PortNumber should be 0 and of Type Int.'  {
            $sessionOptions.PortNumber | Should Be 0
            $sessionOptions.PortNumber.GetType() | Should Be Int
        }

        It "UserName should be $username and of Type String." {
            $sessionOptions.UserName | Should Be $username
            $sessionOptions.UserName.GetType() | Should Be String
        }

        It "Password should be $password and of Type String." {
            $sessionOptions.Password | Should Be $password
            $sessionOptions.Password.GetType() | Should Be String
        }

        It 'SecurePassword should be of Type SecureString.' {
            $sessionOptions.SecurePassword.GetType() | Should Be SecureString
        }

        It 'Timeout should be 15 seconds and of Type TimeSpan.' {
            $sessionOptions.Timeout.Seconds | Should Be 15
            $sessionOptions.Timeout.GetType() | Should Be TimeSpan
        }

        It 'SshHostKeyFingerprint should be null.' {
            $sessionOptions.SshHostKeyFingerprint | Should Be $null
        }

        It 'GiveUpSecurityAndAcceptAnySshHostKey should be false.' {
            $sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey | Should Not Be $true
        }

        It 'SshPrivateKeyPath should be null.' {
            $sessionOptions.SshPrivateKeyPath | Should Be $null
        }

        It 'SshPrivateKeyPassphrase should be null.' {
            $sessionOptions.SshPriaveKeyPassphrase | Should Be $null
        }

        It 'FtpMode should be Passive and of type WinSCP.FtpMode.' {
            $sessionOptions.FtpMode | Should Be Passive
            $sessionOptions.FtpMode.GetType() | Should Be WinSCP.FtpMode
        }

        It 'FtpSecure should be None and of type WinSCP.FtpSecure.' {
            $sessionOptions.FtpSecure | Should Be None
            $sessionOptions.FtpSecure.GetType() | Should be WinSCP.FtpSecure
        }

        It 'WebdavSecure should be false.' {
            $sessionOptions.WebdavSecure | Should Not Be $true
        }

        It 'WebdavRoot should be null.' {
            $sessionOptions.WebdavRoot | Should be $null
        }

        It 'TlsHostCertificateFingerprint should be null.' {
            $sessionOptions.TlsHostCertificateFingerprint | Should Be $null
        }

        It 'GiveUpSecurityAndAcceptAnyTlsHostCertificate should be false.' {
            $sessionOptions.GiveUpSecurityAndAcceptAnyTlsHostCertificate | Should Not Be $true
        }
    }

    Context "New-WinSCPSessionOptions -HostName $server -UserName $username -Password $password -Protocal Sftp -SshHostKeyFingerprint `"ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa`"" {
        $params = @{
            HostName = $server
            UserName = $username
            Password = $password
            Protocol = 'Sftp'
            SshHostKeyFingerprint = 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa'
        }
        
        $sessionOptions = New-WinSCPSessionOptions @params

        It 'Should be of type WinSCP.SessionOptions.' {
            $sessionOptions.GetType() | Should Be WinSCP.SessionOptions
        }

        It 'Protocal should be Sftp and of Type WinSCP.Protocol.' {
            $sessionOptions.Protocol | Should Be Sftp
            $sessionOptions.Protocol.GetType() | Should Be WinSCP.Protocol
        }

        It "HostName should be $server and of Type String." {
            $sessionOptions.HostName | Should Be $server
            $sessionOptions.HostName.GetType() | Should Be String
        }

        It 'PortNumber should be 0 and of Type Int.' {
            $sessionOptions.PortNumber | Should Be 0
            $sessionOptions.PortNumber.GetType() | Should Be Int
        }

        It "UserName should be $username and of Type String." {
            $sessionOptions.UserName | Should Be $username
            $sessionOptions.UserName.GetType() | Should Be String
        }

        It "Password should be $password and of Type String." {
            $sessionOptions.Password | Should Be $password
            $sessionOptions.Password.GetType() | Should Be String
        }

        It 'SecurePassword should be of Type SecureString.' {
            $sessionOptions.SecurePassword.GetType() | Should Be SecureString
        }

        It 'Timeout should be 15 seconds and of Type TimeSpan.' {
            $sessionOptions.Timeout.Seconds | Should Be 15
            $sessionOptions.Timeout.GetType() | Should Be TimeSpan
        }

        It 'SshHostKeyFingerprint should be ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa and of Type String.' {
            $sessionOptions.SshHostKeyFingerprint | Should Be 'ssh-rsa 1024 aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa'
            $sessionOptions.SshHostKeyFingerprint.GetType() | Should Be String
        }

        It 'GiveUpSecurityAndAcceptAnySshHostKey should be false.' {
            $sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey | Should Not Be $true
        }

        It 'SshPrivateKeyPath should be null.' {
            $sessionOptions.SshPrivateKeyPath | Should Be $null
        }

        It 'SshPrivateKeyPassphrase should be null.' {
            $sessionOptions.SshPriaveKeyPassphrase | Should Be $null
        }

        It 'FtpMode should be Passive and of type WinSCP.FtpMode.' {
            $sessionOptions.FtpMode | Should Be Passive
            $sessionOptions.FtpMode.GetType() | Should Be WinSCP.FtpMode
        }

        It 'FtpSecure should be None and of type WinSCP.FtpSecure.' {
            $sessionOptions.FtpSecure | Should Be None
            $sessionOptions.FtpSecure.GetType() | Should be WinSCP.FtpSecure
        }

        It 'WebdavSecure should be false.' {
            $sessionOptions.WebdavSecure | Should Not Be $true
        }

        It 'WebdavRoot should be null.' {
            $sessionOptions.WebdavRoot | Should be $null
        }

        It 'TlsHostCertificateFingerprint should be null.' {
            $sessionOptions.TlsHostCertificateFingerprint | Should Be $null
        }

        It 'GiveUpSecurityAndAcceptAnyTlsHostCertificate should be false.' {
            $sessionOptions.GiveUpSecurityAndAcceptAnyTlsHostCertificate | Should Not Be $true
        }
    }
}