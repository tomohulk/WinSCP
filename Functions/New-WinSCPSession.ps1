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
.PARAMETER WinSCPSession
    An existing WinSCP.Session Object to be re-opened.
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -HostName $env:COMPUTERNAME -UserName $env:USERNAME -Protocol Ftp

    PS C:\> $session


    ExecutablePath                : 
    AdditionalExecutableArguments : 
    DefaultConfiguration          : True
    DisableVersionCheck           : False
    IniFilePath                   : 
    ReconnectTime                 : 00:02:00
    ReconnectTimeInMilliseconds   : 120000
    DebugLogPath                  : 
    DebugLogLevel                 : 0
    SessionLogPath                : 
    XmlLogPath                    : C:\Users\$env:USERNAME\AppData\Local\Temp\wscp6934.0246B60F.tmp
    HomePath                      : /
    Timeout                       : 00:01:00
    Output                        : {winscp> option batch on, batch           on        , reconnecttime   120       , winscp> option 
                                    confirm off...}
    Opened                        : True
    UnderlyingSystemType          : WinSCP.Session
.NOTES
    This function is used to open a WinSCP Session to be used with most other cmdlets in in the WinSCP PowerShell Module.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session
.LINK
    http://winscp.net/eng/docs/library_sessionoptions
#>
Function New-WinSCPSession
{
    [CmdletBinding(DefaultParameterSetName = 'NewSession')]
    [OutputType([WinSCP.Session])]
    
    Param
    (
        [Parameter(ParameterSetName = 'NewSession')]
        [WinSCP.FtpMode]
        $FtpMode = (New-Object -TypeName WinSCP.FtpMode),

        [Parameter(ParameterSetName = 'NewSession')]
        [WinSCP.FtpSecure]
        $FtpSecure = (New-Object -TypeName WinSCP.FtpSecure),
        
        [Parameter(ParameterSetName = 'NewSession')]
        [Switch]
        $GiveUpSecurityAndAcceptAnySshHostKey,

        [Parameter(ParameterSetName = 'NewSession')]
        [Switch]
        $GiveUpSecureityAndAcceptAnyTlsHostCertificate,

        [Parameter(Mandatory = $true,
                   ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $HostName = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Password = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [Int]
        $PortNumber = 0,

        [Parameter(ParameterSetName = 'NewSession')]
        [WinSCP.Protocol]
        $Protocol = (New-Object -TypeName WinSCP.Protocol),

        [Parameter(ParameterSetName = 'NewSession')]
        [System.Security.SecureString]
        $SecurePassword = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $SshHostKeyFingerprint = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ if (Test-Path -Path $_)
            { 
                return $true 
            } 
            else 
            { 
                throw "$_ not found." 
            } })]
        [String]
        $SshPrivateKeyPath = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $SshPrivateKeyPassphrase = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $TlsHostCertificateFingerprint = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [TimeSpan]
        $Timeout = (New-TimeSpan -Seconds 15),

        [Parameter(Mandatory = $true,
                   ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $UserName = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [Switch]
        $WebdavSecure,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $WebdavRoot = $null,
        
        [Parameter(ParameterSetName = 'NewSession')]
        [HashTable]
        $RawSetting = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({if (Test-Path -Path (Split-Path -Path $_))
            {
                return $true
            }
            else
            {
                throw "Path not found $(Split-Path -Path $_)."
            } })]
        [String]
        $DebugLogPath = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [ValidateScript({if (Test-Path -Path (Split-Path -Path $_))
            {
                return $true
            }
            else
            {
                throw "Path not found $(Split-Path -Path $_)."
            } })]
        [String]
        $SessionLogPath = $null,

        [Parameter(ParameterSetName = 'NewSession')]
        [TimeSpan]
        $ReconnectTime = (New-TimeSpan -Seconds 120),

        [Parameter(ParameterSetName = 'OpenSession')]
        [WinSCP.Session]
        $WinSCPSession = $null
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'OpenSession' {
            try
            {
                $WinSCPSession.Open()

                return $WinSCPSession
            }
            catch
            {
                Write-Error -Message $_.ToString()
            }
        }

        default {
            $sessionOptions = New-Object -TypeName WinSCP.SessionOptions
            $session = New-Object -TypeName WinSCP.Session

            try
            {
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
            catch
            {
                Write-Error -Message $_.ToString()
            }

            try
            {
                $session.Open($sessionOptions)

                return $session
            }
            catch
            {
                Write-Error -Message $_.ToString()
            }
        }
    }
}