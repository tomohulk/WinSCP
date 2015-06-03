<#
.SYNOPSIS
    Defines information to allow an automatic connection and authentication of the session.
.DESCRIPTION
    Defines all settings that can be configrued for the WinSCP.SessionOptions Object, then opens and returns the WinSCP.Session Object.
.INPUTS
    None.
.OUTPUTS
    WinSCP.Session.
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
.PARAMETER RawSettings
    A Hashtable of Settings and Values to add to the WinSCP.SessionOptions Object.
.PARAMETER DebugLogPath
    Path to store assembly debug log to. Default null means, no debug log file is created. See also SessionLogPath. The property has to be set before calling Open.
.PARAMETER SessionLogPath
    Path to store session log file to. Default null means, no session log file is created.
.PARAMETER  ReconnectTime
    Sets time limit in seconds to try reconnecting broken sessions. Default is 120 seconds. Use TimeSpan.MaxValue to remove any limit.
#>
Function New-WinSCPSession
{
    [OutputType([WinSCP.Session])]
    
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
        $GiveUpSecureityAndAcceptAnyTlsHostCertificate,

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
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $SshHostKeyFingerprint,

        [Parameter()]
        [ValidateScript({ if (Test-Path -Path $_)
            { 
                return $true 
            } 
            else 
            { 
                throw "$_ not found." 
            } })]
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
        $WebdavRoot,
        
        [Parameter()]
        [HashTable]
        $RawSetting,

        [Parameter()]
        [ValidateScript({if (Test-Path -Path (Split-Path -Path $_))
            {
                return $true
            }
            else
            {
                throw "Path not found $(Split-Path -Path $_)."
            } })]
        [String]
        $DebugLogPath,

        [Parameter()]
        [ValidateScript({if (Test-Path -Path (Split-Path -Path $_))
            {
                return $true
            }
            else
            {
                throw "Path not found $(Split-Path -Path $_)."
            } })]
        [String]
        $SessionLogPath,

        [Parameter()]
        [TimeSpan]
        $ReconnectTime
    )

    try
    {
        $sessionOptions = New-Object -TypeName WinSCP.SessionOptions
        $session = New-Object -TypeName WinSCP.Session

        foreach ($key in $PSBoundParameters.Keys)
        {
            if (($sessionOptions | Get-Member -MemberType Properties).Name -contains $key)
            {
                $sessionOptions.$key = $PSBoundParameters.$key
            }
            elseif (($session | Get-Member -MemberType Properties).Name -contains $key)
            {
                $session.$key = $PSBoundParameters.$key
            }
        }

        foreach ($key in $RawSetting.Keys)
        {
            $sessionOptions.AddRawSettings($key, $RawSetting[$key])
        }
    }
    catch [System.Exception]
    {
        throw $_
    }

    try
    {
        $session.Open($sessionOptions)
        return $session
    }
    catch [System.Exception]
    {
        throw $_
    }
}
