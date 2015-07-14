<#
.SYNOPSIS
    Defines information to allow an automatic connection and authentication of the session.
.DESCRIPTION
    Defines all settings that can be configrued for the WinSCP.SessionOptions Object, then opens and returns the WinSCP.Session Object.
.INPUTS
    System.Management.Automation.PSCredential.
.OUTPUTS
    WinSCP.Session.
.PARAMETER Credential
    PSCredential object used for authentication.
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
.PARAMETER Protocol
    Protocol to use for the session. Possible values are Protocol.Sftp (default), Protocol.Scp, Protocol.Ftp and Protocol.Webdav.
.PARAMETER SshHostKeyFingerprint
    Fingerprint of SSH server host key (or several alternative fingerprints separated by semicolon). It makes WinSCP automatically accept host key with the fingerprint. Mandatory for SFTP/SCP protocol.
.PARAMETER SshPrivateKeyPath 
    Full path to private key file.
.PARAMETER SshPrivateKeySecurePassphrase
    Passphrase for encrypted private keys.
.PARAMETER TlsHostCertificateFingerprint
    Fingerprint of FTPS/WebDAVS server TLS/SSL certificate to be automatically accepted (useful for certificates signed by untrusted authority).
.PARAMETER Timeout
    Server response timeout. Defaults to 15 seconds.
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
.PARAMETER FileTransferProgress
    Adds the ability to run a script block for each file transfer.
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -HostName $env:COMPUTERNAME -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -Protocol Ftp

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
    This function is used to open a WinSCP Session to be used with most other cmdlets in the WinSCP PowerShell Module.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session
.LINK
    http://winscp.net/eng/docs/library_sessionoptions
#>
Function New-WinSCPSession
{
    [OutputType([WinSCP.Session])]
    
    Param
    (
        [Parameter(ValueFromPipeline = $true)]
        [PSCredential]
        $Credential = (Get-Credential),

        [Parameter()]
        [WinSCP.FtpMode]
        $FtpMode = (New-Object -TypeName WinSCP.FtpMode),

        [Parameter()]
        [WinSCP.FtpSecure]
        $FtpSecure = (New-Object -TypeName WinSCP.FtpSecure),
        
        [Parameter()]
        [Switch]
        $GiveUpSecurityAndAcceptAnySshHostKey,

        [Parameter()]
        [Switch]
        $GiveUpSecureityAndAcceptAnyTlsHostCertificate,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $HostName = $null,

        [Parameter()]
        [Int]
        $PortNumber = 0,

        [Parameter()]
        [WinSCP.Protocol]
        $Protocol = (New-Object -TypeName WinSCP.Protocol),

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $SshHostKeyFingerprint = $null,

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
        $SshPrivateKeyPath = $null,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [SecureString]
        $SshPrivateKeySecurePassphrase = $null,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $TlsHostCertificateFingerprint = $null,

        [Parameter()]
        [TimeSpan]
        $Timeout = (New-TimeSpan -Seconds 15),

        [Parameter()]
        [Switch]
        $WebdavSecure,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $WebdavRoot = $null,
        
        [Parameter()]
        [HashTable]
        $RawSetting = $null,

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
        $DebugLogPath = $null,

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
        $SessionLogPath = $null,

        [Parameter()]
        [TimeSpan]
        $ReconnectTime = (New-TimeSpan -Seconds 120),

        [Parameter()]
        [ScriptBlock]
        $FileTransferProgress = $null
    )

    # Create WinSCP.Session and WinSCP.SessionOptions Objects, parameter values will be assigned to matching object properties.
    $sessionOptions = New-Object -TypeName WinSCP.SessionOptions
    $session = New-Object -TypeName WinSCP.Session

    # Convert PSCredential Object to match names of the WinSCP.SessionOptions Object.
    $PSBoundParameters.Add('UserName', $Credential.UserName)
    $PSBoundParameters.Add('SecurePassword', $Credential.Password)

    # Convert SshPrivateKeyPasspahrase to plain text.
    if ($SshPrivateKeySecurePassphrase -ne $null)
    {
        $sessionOptions.SshPrivateKeyPassphrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SshPrivateKeySecurePassphrase))
    }

    try
    {
        # Enumerate each parameter.
        foreach ($key in $PSBoundParameters.Keys)
        {
            # If the property is a member of the WinSCP.SessionOptions object, set the matching value.
            if (($sessionOptions | Get-Member -MemberType Properties).Name -contains $key)
            {
                $sessionOptions.$key = $PSBoundParameters.$key
            }
            # If the property is a member of the WinSCP.Session object, set the matching value.
            elseif (($session | Get-Member -MemberType Properties).Name -contains $key)
            {
                $session.$key = $PSBoundParameters.$key
            }
        }

        # Enumerate raw settings and add the options to the WinSCP.SessionOptions object.
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
        if ($FileTransferProgress -ne $null)
        {
            $session.Add_FileTransferProgress($FileTransferProgress)
        }

        # Open the WinSCP.Session object using the WinSCP.SessionOptions object.
        $session.Open($sessionOptions)

        # Return the WinSCP.Session object.
        return $session
    }
    catch
    {
        Write-Error -Message $_.ToString()
    }
}