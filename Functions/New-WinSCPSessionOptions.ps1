<#
.SYNOPSIS
    Defines information to allow an automatic connection and authentication of the session.
.DESCRIPTION
    This object with valid settings is required when opening a connection to a remote server.
.INPUTS
    None.
.OUTPUTS
    WinSCP.SessionOptions.
.PARAMETER FtpMode
    Possible values are FtpMode.Passive (default) and FtpMode.Active.
.PARAMETER FtpSecure
    FTPS mode. Possible values are FtpSecure.None (default), FtpSecure.Implicit and FtpSecure.Explicit (FtpSecure.ExplicitTls in older versions).
.PARAMETER GiveUpSecurityAndAcceptAnySshHostKey
    Give up security and accept any SSH host key. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use SshHostKeyFingerprint.
.PARAMETER GiveUpSecurityAndAcceptAnyTlsHostCertificate
    Give up security and accept any FTPS/WebDAVS server TLS/SSL certificate. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use TlsHostCertificateFingerprint.
.PARAMETER HostName
    Name of the host to connect to. Mandatory property.
.PARAMETER Password
    Password for authentication.
.PARAMETER Protocol
    Protocol to use for the session. Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp and Protocol.Webdav.
.PARAMETER SecurePassword
    Encrypted password for authentication. Use instead of Password to reduce a number of unencrypted copies of the password in memory.
.PARAMETER SshHostKeyFingerprint
    Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon). It makes WinSCP automatically accept host key with the fingerprint. Mandatory for SFTP/SCP protocol.
.PARAMETER SshPrivateKeyPath 
    Full path to private key file.
.PARAMETER SshPrivateKeyPassphrase
    Passphrase for encrypted private keys.
.PARAMETER TlsHostCertificateFingerprint
    Fingerprint of FTPS/WebDAVS server TLS/SSL certificate to be automatically accepted (useful for certificates signed by untrusted authority).
.PARAMETER Timeout
    Server response timeout. Defaults to 15 seconds.
.PARAMETER UserName
    Username for authentication. Mandatory property.
.PARAMETER WebdavSecure
    Use WebDAVS (WebDAV over TLS/SSL), instead of WebDAV.
.PARAMETER WebdaveRoot
    WebDAV root path.
.EXAMPLE
    PS C:\> New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -password "FtpUserPword" -Protocol Ftp

    Protocol                                     : Ftp
    HostName                                     : myftphost.org
    PortNumber                                   : 0
    UserName                                     : ftpuser
    Password                                     : FtpUserPword
    SecurePassword                               : System.Security.SecureString
    Timeout                                      : 00:00:15
    TimeoutInMilliseconds                        : 15000
    SshHostKeyFingerprint                        : 
    GiveUpSecurityAndAcceptAnySshHostKey         : False
    SshPrivateKeyPath                            : 
    SshPrivateKeyPassphrase                      : 
    FtpMode                                      : Passive
    FtpSecure                                    : None
    WebdavSecure                                 : False
    WebdavRoot                                   : 
    TlsHostCertificateFingerprint                : 
    GiveUpSecurityAndAcceptAnyTlsHostCertificate : False
.EXAMPLE
    PS C:\> New-WinSCPSessionOptions -Hostname "myftphost.org" -Username ftpuser -SecurePassword (ConvertTo-SecureString -String "FtpUserPword" -AsPlainText -Force) -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"

    Protocol                                     : Sftp
    HostName                                     : myftphost.org
    PortNumber                                   : 0
    UserName                                     : ftpuser
    Password                                     : FtpUserPword
    SecurePassword                               : System.Security.SecureString
    Timeout                                      : 00:00:15
    TimeoutInMilliseconds                        : 15000
    SshHostKeyFingerprint                        : ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
    GiveUpSecurityAndAcceptAnySshHostKey         : False
    SshPrivateKeyPath                            : 
    SshPrivateKeyPassphrase                      : 
    FtpMode                                      : Passive
    FtpSecure                                    : None
    WebdavSecure                                 : False
    WebdavRoot                                   : 
    TlsHostCertificateFingerprint                : 
    GiveUpSecurityAndAcceptAnyTlsHostCertificate : False
.NOTES
    If the Sftp/Scp protocols are used, a SshHostKeyFingerprint will become a mandatory parameter.
    Be sure to assign the SessionOptions to a variable, else it will be auto disposed.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_sessionoptions
#>
Function New-WinSCPSessionOptions
{
    [CmdletBinding()]
    [OutputType([WinSCP.SessionOptions])]
    
    Param
    (
        [Parameter()]
        [WinSCP.FtpMode]
        $FtpMode,

        [Parameter()]
        [WinSCP.FtpSecure]
        $FtpSecure,
        
        [Parameter()]
        [Switch]
        $GiveUpSecurityAndAcceptAnySshHostKey,

        [Parameter()]
        [Switch]
        $GiveUpSecureityAndAcceptANyTlsHostCertificate,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $HostName,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Password,

        [Parameter()]
        [Int]
        $PortNumber = 0,

        [Parameter()]
        [WinSCP.Protocol]
        $Protocol,

        [Parameter()]
        [System.Security.SecureString]
        $SecurePassword,

        [Parameter()]
        [ValidateScript({ if (Test-Path -Path $_){ return $true } else { throw "$_ not found." } })]
        [String]
        $SshPrivateKeyPath,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $SshPrivateKeyPassphrase,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $TlsHostCertificateFingerprint,

        [Parameter()]
        [TimeSpan]
        $Timeout,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $UserName,

        [Parameter()]
        [Switch]
        $WebdavSecure,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $WebdavRoot
    )

    DynamicParam {
        $SshHostKeyFingerprintAttribute = New-Object -TypeName Management.Automation.ParameterAttribute

        if (-not ($PSBoundParameters.ContainsKey('Protocol')) -or ($PSBoundParameters.Protocol -eq 'Sftp') -or ($PSBoundParameters.Protocol -eq 'Scp') -and (-not ($GiveUpSecurityAndAcceptAnySshHostKey.IsPresent)))
        {
            $SshHostKeyFingerprintAttribute.Mandatory = $true
        }

        $SshHostKeyFingerprintAttributeCollection = New-Object -TypeName Collections.ObjectModel.Collection[$SshHostKeyFingerprintAttribute]
        $SshHostKeyFingerprintAttributeCollection.Add($SshHostKeyFingerprintAttribute)

        $SshHostKeyFingerprintParameter = @{
            TypeName = 'Management.Automation.RuntimeDefinedParameter'
            ArgumentList = @(
                'SshHostKeyFingerprint'
                [String]
                $SshHostKeyFingerprintAttributeCollection
            )
        }

        $ParameterDictionary = New-Object -TypeName Management.Automation.RuntimeDefinedParameterDictionary
        $ParameterDictionary.Add('SshHostKeyFingerprint', (New-Object @SshHostKeyFingerprintParameter))
        return $ParameterDictionary
    }

    Begin
    {
        $sessionOptions = New-Object -TypeName WinSCP.SessionOptions

        foreach ($key in $PSBoundParameters.Keys)
        {
            try
            {
                $sessionOptions.$($key) = $PSBoundParameters.$($key)
            }
            catch [System.Exception]
            {
                throw $_
            }
        }
    }

    End
    {
        return $sessionOptions
    }
}