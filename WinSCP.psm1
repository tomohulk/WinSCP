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
.PRAMETER FtpSecure
    FTPS mode. Possible values are FtpSecure.None (default), FtpSecure.Implicit and FtpSecure.Explicit (FtpSecure.ExplicitTls in older versions).
.PARAMETER GiveUpSecurityAndAcceptAnySshHostKey
    Give up security and accept any SSH host key. To be used in exceptional situations only, when security is not required. When set, log files will include warning about insecure connection. To maintain security, use SshHostKeyFingerprint.
.PAREMETER GiveUpSecurityAndAcceptAnyTlsHostCertificate
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
    http://dotps1.github.io
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
        [String]
        $HostName,

        [Parameter()]
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
        [String]
        $SshPrivateKeyPassphrase,

        [Parameter()]
        [String]
        $TlsHostCertificateFingerprint,

        [Parameter()]
        [TimeSpan]
        $Timeout,

        [Parameter(Mandatory = $true)]
        [String]
        $UserName,

        [Parameter()]
        [Switch]
        $WebdavSecure,

        [Parameter()]
        [String]
        $WebdavRoot
    )

    DynamicParam {
        $SshHostKeyFingerprintAttribute = New-Object -TypeName Management.Automation.ParameterAttribute

        if (-not($PSBoundParameters.ContainsKey('Protocol')) -or ($PSBoundParameters.Protocol -eq "Sftp") -or ($PSBoundParameters.Protocol -eq "Scp"))
        {
            $SshHostKeyFingerprintAttribute.Mandatory = $true
        }

        $SshHostKeyFingerprintAttributeCollection = New-Object Collections.ObjectModel.Collection[$SshHostKeyFingerprintAttribute]
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
        $ParameterDictionary.Add("SshHostKeyFingerprint", (New-Object @SshHostKeyFingerprintParameter))
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
                Write-Error $_
            }
        }
    }

    End
    {
        return $sessionOptions
    }
}

<#
.SYNOPSIS
    This is the main interface class of the WinSCP assembly.
.DESCRIPTION
    Creates a new WINSCP.Session Object with setting specified in the WinSCP.SessionOptions object.  Assign this Object to a Variable to easily manipulate actions later.
.INPUTS
    WinSCP.SessionOptions.
.OUTPUTS
    WinSCP.Session.
.PARAMETER SessionOptions
    Defines information to allow an automatic connection and authentication of the session.
.PARAMETER SessionLogPath
    Path to store session log file to. Default null means, no session log file is created.
.EXAMPLE
    PS C:\> $session = Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp)
    PS C:\> $session

    ExecutablePath                : 
    AdditionalExecutableArguments : 
    DefaultConfiguration          : True
    DisableVersionCheck           : False
    IniFilePath                   : 
    ReconnectTime                 : 10675199.02:48:05.4775807
    DebugLogPath                  : 
    SessionLogPath                : 
    XmlLogPath                    : C:\Users\user\AppData\Local\Temp\wscp0708.03114C7C.tmp
    Timeout                       : 00:01:00
    Output                        : {winscp> option batch on, batch           on        , winscp> option confirm off, confirm         off       ...}
    Opened                        : True
    UnderlyingSystemType          : WinSCP.Session
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp | Open-WinSCPSession
    PS C:\> $session

    ExecutablePath                : 
    AdditionalExecutableArguments : 
    DefaultConfiguration          : True
    DisableVersionCheck           : False
    IniFilePath                   : 
    ReconnectTime                 : 10675199.02:48:05.4775807
    DebugLogPath                  : 
    SessionLogPath                : 
    XmlLogPath                    : C:\Users\user\AppData\Local\Temp\wscp0708.03114C7C.tmp
    Timeout                       : 00:01:00
    Output                        : {winscp> option batch on, batch           on        , winscp> option confirm off, confirm         off       ...}
    Opened                        : True
    UnderlyingSystemType          : WinSCP.Session
.NOTES
    If the WinSCPSession is piped into another WinSCP command, the connection will be disposed upon completion of that command.
    Be sure to store the WinSCPSession into a vairable, else there will be no handle to use with it.
.INPUTS
    WinSCP.SessionOptions.
.OUTPUTS
    WinSCP.Session.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session
#>
Function Open-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([WinSCP.Session])]

    Param
    (   
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [WinSCP.SessionOptions]
        $SessionOptions,

        [Parameter()]
        [String]
        $SessionLogPath = $null
    )

    $session = New-Object -TypeName WinSCP.Session -Property @{
        SessionLogPath = $SessionLogPath
    }
    
    try
    {
        $session.Open($SessionOptions)
        return $session
    }
    catch [System.Exception]
    {
        Write-Error $_
    }
}

<#
.SYNOPSIS
    Closes/Disposes an active WinSCP Session Object.
.DESCRIPTION
    After a WinSCP Session is no longer needed this function will dispose the COM object.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    The active WinSCP Session to close.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Close-WinSCPSession
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Close-WinSCPSession -WinSCPSession $session
.NOTES
    If the WinSCPSession is piped into another WinSCP command, this function will be called to auto dispose th connection upon complete of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session
#>
Function Close-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([Void])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession
    )

    try
    {
        $WinSCPSession.Dispose()
    }
    catch [System.Exception]
    {
        Write-Error $_
    }
}

<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER RemotePath
    Full path to remote directory followed by slash and wildcard to select files or subdirectories to download. When wildcard is omitted (path ends with slash), all files and subdirectories in the remote directory are downloaded.
.PARAMETER LocalPath
    Full path to download the file to. When downloading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with slash). 
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions. 
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Receive-WinSCPItem -RemotePath "rDir/rFile.txt" -LocalPath "C:\lDir\lFile.txt"

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Receive-WinSCPItem -WinSCPSession $session -RemotePath "rDir/rFile.txt" -LocalPath "C:\lDir\lFile.txt" -Remove

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_getfiles
#>
Function Receive-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $RemotePath,

        [Parameter()]
        [String]
        $LocalPath = "$(Get-Location)\",

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $RemotePath.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.GetFiles($item, $LocalPath, $Remove.IsPresent, $TransferOptions)
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Send file(s) to an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to send file(s).
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER LocalPath
    Full path to local file or directory to upload. Filename in the path can be replaced with Windows wildcard to select multiple files. When file name is omitted (path ends with backslash), all files and subdirectories in the local directory are uploaded.
.PARAMETER RemotePath
    Full path to upload the file to. When uploading multiple files, the filename in the path should be replaced with ConvertTo-WinSCPEscapedString or omitted (path ends with slash). 
.PARAMETER Remove
    When present, deletes source local file(s) after transfer.
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Send-WinSCPItem -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt"
    
    Transfers           Failures IsSuccess
    ---------           -------- ---------
    {C:\lDir\lFile.txt} {}       True 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Send-WinSCPItem -WinSCPSession $session -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt" -Remove

    Transfers           Failures IsSuccess
    ---------           -------- ---------
    {C:\lDir\lFile.txt} {}       True 
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_putfiles
#>
Function Send-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $LocalPath,

        [Parameter()]
        [String]
        $RemotePath = "./",
        
        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions,

        [Parameter()]
        [Switch]
        $Remove
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $LocalPath)
        {
            try
            {
                $WinSCPSession.PutFiles($item, $RemotePath.Replace("\","/"), $Remove.IsPresent, $TransferOptions)
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Creates a directory on an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to create new directory or nested directories.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote directory to create.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | New-WinSCPDirectory -Path "rDir/rSubDir"

    Name            : /rDir/rSubDir
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> New-WinSCPDirectory -WinSCPSession $session -Path "rDir/rSubDir"

    Name            : /rDir/rSubDir
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_createdirectory
#>
Function New-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [Alias("Dir")]
        [String[]]
        $Path
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach($item in $Path.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.CreateDirectory($item)
                return ($WinSCPSession.GetFileInfo($item))
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Test if a remote item exists.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to test if a directory or file exists on the remote source.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    System.Boolean.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote file.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Test-WinSCPItemExists -Path "rDir/rSubDir"

    True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Test-WinSCPItemExists -WinSCPSession $session -Path "rDir/rSubDir"

    True
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_fileexists
#>
Function Test-WinSCPItemExists
{
    [CmdletBinding()]
    [OutputType([Bool])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $Path
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach($item in $Path.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.FileExists($item)
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Retrieves information about a File or Directory from an active WinSCP Session.
.DESCRIPTION
    Retrieves Name, FileType, Length, LastWriteTime, FilePermissions, and IsDirectory Properties on an Item from an Active WinSCP Session.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote file.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Get-WinSCPItemInformation -RemotePath "rDir/rSubDir"
    
    Name            : /rDir/rSubDir
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Get-WinSCPItemInformation -WinSCPSession $session -Path "rDir/rSubDir"

    Name            : /rDir/rSubDir
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_getfileinfo
#>
Function Get-WinSCPItemInformation
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $Path
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $Path.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.GetFileInfo($item)
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Shows the contents of a remote directory.
.DESCRIPTION
    Displays the contents within a remote directory, including other directories and files.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteDirectoryInfo
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote directory to be read.
.PARAMETER ShowDetails
    Display expanded details about each item.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Get-WinSCPDirectoryContents -Path "rDir/"
    
    Files
    -----
    {.., lFile.txt, rSubDir} 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Get-WinSCPDirectoryContents -WinSCPSession $session -Path "rDir/" -ShowDetails

    Name            : ..
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True

    Name            : lFile.txt
    FileType        : -
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : False

    Name            : rSubDir
    FileType        : D
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_listdirectory
#>
Function Get-WinSCPDirectoryContents
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteDirectoryInfo])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [Alias("Dir")]
        [String[]]
        $Path,

        [Parameter()]
        [Switch]
        $ShowDetails
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $Path.Replace("\","/"))
        {
            try
            {
                if ($ShowDetails.IsPresent)
                {
                    $WinSCPSession.ListDirectory($item).Files
                }
                else
                {
                    $WinSCPSession.ListDirectory($item)
                }
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Moves an item from one location to another from an active WinSCP Session.
.DESCRIPTION
    Once connected to an active WinSCP Session, one or many files can be moved to another location within the same WinSCP Session.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER SourcePath
    Full path to remote file to move/rename.
.PARAMETER TargetPath
    Full path to new location/name to move/rename the file to.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Move-WinSCPItem -SourcePath "rDir/rFile.txt" -TargetPath rDir/rSubDir/rFile.txt
    
    Name            : /rDir/rSubDir/rFile.txt
    FileType        : -
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : False 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Move-WinSCPItem -WinSCPSession $session -SourcePath "rDir/rFile.txt" -TargetPath rDir/rSubDir/rFile.txt

    Name            : /rDir/rSubDir/rFile.txt
    FileType        : -
    Length          : 0
    LastWriteTime   : 1/1/2015 12:00:00 AM
    FilePermissions : ---------
    IsDirectory     : False 
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK 
    http://winscp.net/eng/docs/library_session_movefile
#>
Function Move-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [Alias("Source")]
        [String[]]
        $SourcePath,

        [Parameter(Mandatory = $true)]
        [Alias("Target")]
        [String]
        $TargetPath
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $SourcePath.Replace("\","/"))
        {
            try
            {
                $filename = $item.Substring($item.LastIndexOf("/") + 1)
                $destination = $TargetPath.Replace("\","/")
                $WinSCPSession.MoveFile($item, $destination)
                if ($destination.EndsWith("/"))
                {
                    return $WinSCPSession.GetFileInfo($destination + $filename)
                }
                else
                {
                    return $WinSCPSession.GetFileInfo($destination)
                }
                
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Removes and item from an active WinSCP Session.
.DESCRIPTION
    Removes and item, File or Directory from a remote sources.  This action will recurse if a the $Path value is a directory.
.INPUTS.
    WinSCP.Session.
.OUTPUTS.
    WinSCP.RemovalOperationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote directory followed by slash and wildcard to select files or subdirectories to remove. 
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Remove-WinSCPItem -Path "rDir/rFile.txt"

    Removals                  Failures IsSuccess
    --------                  -------- ---------
    {/rDir/rSubDir/rFile.txt} {}       True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Remove-WinSCPItem -WinSCPSession $session -Path "rDir/rFile.txt"

    Removals                  Failures IsSuccess
    --------                  -------- ---------
    {/rDir/rSubDir/rFile.txt} {}       True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_removefiles
#>
Function Remove-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemovalOperationResult])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $Path
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($item in $Path.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.RemoveFiles($item)
            }
            catch [System.Exception]
            {
                Write-Error $_
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Synchronizes directories with an active WinSCP Session.
.DESCRIPTION
    Synchronizes a local directory with a remote directory, or vise versa.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.SynchronizationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Mode
    Synchronization mode. Possible values are Local, Remote and Both. 
.PARAMETER LocalPath
    Full path to local directory.
.PARAMETER RemotePath
    Full path to remote directory.
.PARAMETER Remove
    When used, deletes obsolete files. Cannot be used with -Mode Both.
.PARAMETER Mirror
    When used, synchronizes in mirror mode (synchronizes also older files). Cannot be used for -Mode Both.
.PARAMETER Criteria
    Comparison criteria. Possible values are None, Time (default), .Size and Either. For -Mode Both Time can be used only.
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-WinSCPTransferOptions. 
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Sync-WinSCPDirectory -RemotePath "./" -LocalPath "C:\lDir\" -Mode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Sync-WinSCPDirectory -WinSCPSession $session -RemotePath "./" -LocalPath "C:\lDir\" -SyncMode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_synchronizedirectories
#>
Function Sync-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.SynchronizationResult])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Local','Remote','Both')]
        [String]
        $Mode,

        [Parameter()]
        [String]
        $LocalPath = "$(Get-Location)\",

        [Parameter()]
        [String]
        $RemotePath = "./",

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [Switch]
        $Mirror,

        [Parameter()]
        [ValidateSet('None','Time','Size','Either')]
        [String]
        $Criteria = 'Time',

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        try
        {
            $WinSCPSession.SynchronizeDirectories([WinSCP.SynchronizationMode]::$Mode, $LocalPath.Replace("/","\"), $RemotePath.Replace("\","/"), $Remove.IsPresent, $Mirror.IsPresent, [WinSCP.SynchronizationCriteria]::$Criteria, $TransferOptions)
        }
        catch [System.Exception]
        {
            Write-Error $_
            return
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}

<#
.SYNOPSIS
    Escapes special characters in string.
.DESCRIPTION
    Escapes special characters so they are not misinterpreted as wildcards or other special characters.
.INPUTS
   None.
.OUTPUTS
    System.String.
.PARAMETER FileMask
    File path to convert.
.EXAMPLE
    ConvertTo-WinSCPEscapedString -FileMask "*.txt"

    [*].txt
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    $searchString = ConvertTo-WinSCPEscapedString -FileMask "*.txt"
    Receive-WinSCPItem -WinSCPSession $session -RemoteItem "./rDir/$searchString" -LocalItem "C:\lDir\"
.NOTES
    Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_escapefilemask
#>
Function ConvertTo-WinSCPEscapedString
{
    [CmdletBinding()]
    [OutputType([String])]

    Param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FileMask
    )

    Begin
    {
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    Process
    {
        try
        {
            return ($sessionObject.EscapeFileMask($FileMask))
        }
        catch [System.Exception]
        {
            Write-Error $_
            return
        }
    }
    
    End
    {
        $sessionObject.Dispose()
    }
}

<#
.SYNOPSIS
    Sets options for file transfers.
.DESCRIPTION
    Sets available options for file transfers between the client and server.
.INPUTS
    None.
.OUTPUTS
    WinSCP.TransferOptions.
.PARAMETER FileMask
    http://winscp.net/eng/docs/file_mask
.PARAMETER FilePermissions
    Permissions to applied to a remote file (used for uploads only).
.PARAMETER PreserveTimeStamp
    Preserve timestamp (set last write time of destination file to that of source file). Defaults to true.
.PARAMETER TransferMode
    Possible values are TransferMode.Binary (default), TransferMode.Ascii and TransferMode.Automatic (based on file extension).
.EXAMPLE
    PS C:\> New-WinSCPTransferOptions -PreserveTimeStamp -TransferMode Binary

    PreserveTimestamp : True
    FilePermissions   : 
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
.EXAMPLE
    PS C:\> New-WinSCPTransferOptions -FilePermissions (New-WinSCPFilePermissions -GroupExecute -OtherRead)

    PreserveTimestamp : True
    FilePermissions   : -----xr--
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
.NOTES
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_transferoptions
#>
Function New-WinSCPTransferOptions
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOptions])]

    Param
    (
        [Parameter()]
        [String]
        $FileMask,

        [Parameter()]
        [WinSCP.FilePermissions]
        $FilePermissions,

        [Parameter()]
        [Switch]
        $PreserveTimeStamp,

        [Parameter()]
        [ValidateSet("Binary","Ascii","Automatic")]
        [WinSCP.TransferMode]
        $TransferMode
    )

    Begin
    {
        $transferOptions = New-Object -TypeName WinSCP.TransferOptions

        foreach ($key in $PSBoundParameters.Keys)
        {
            try
            {
                $transferOptions.$($key) = $PSBoundParameters.$($key)
            }
            catch [System.Exception]
            {
                Write-Error $_
            }
        }
    }

    End
    {
        return $transferOptions
    }
}

<#
.SYNOPSIS
    Represents *nix-style remote file permissions.
.DESCRIPTION
    Creates a new WinSCP.FilePermmissions object that can be used with Send-WinSCPItem to apply permissions.
.INPUTS
    None.
.OUTPUTS
    WinSCP.FilePermissions.
.PARAMETER GroupExecute
    Execute permission for group.
.PARAMETER GroupRead
    Read permission for group.
.PARAMETWER GroupWrite
    Read permission for group.
.PARAMETER Numeric
    Permissions as a number.
.PARAMETER Octal
    Permissions in octal format, e.g. "644". Octal format has 3 or 4 (when any special permissions are set) digits.
.PARAMETWER OtherExecute
    Execute permission for others.
.PARAMETER OtherRead
    Read permission for others.
.PARAMETER OtherWrite
    Write permission for others.
.PARAMETER SetGid
    Grants the user, who executes the file, permissions of file group.
.PARAMETER SetUid
    Grants the user, who executes the file, permissions of file owner.
.PARAMETER Sticky
    Sticky bit.
.PARAMETER Text
    Permissions as a text in format "rwxrwxrwx".
.PARAMETER UserExecute
    Execute permission for owner.
.PARAMETER UserRead
    Read permission for owner.
.PARAMETER UserWrite
    Write permission for owner.
.EXAMPLE
    New-WinSCPFilePermissions

    Numeric      : 0
    Text         : ---------
    Octal        : 000
    OtherExecute : False
    OtherWrite   : False
    OtherRead    : False
    GroupExecute : False
    GroupWrite   : False
    GroupRead    : False
    UserExecute  : False
    UserWrite    : False
    UserRead     : False
    Sticky       : False
    SetGid       : False
    SetUid       : False
.EXAMPLE
    New-WinSCPFilePermissions -GroupExecute -GroupRead -UserExecute -UserRead

    Numeric      : 360
    Text         : r-xr-x---
    Octal        : 550
    OtherExecute : False
    OtherWrite   : False
    OtherRead    : False
    GroupExecute : True
    GroupWrite   : False
    GroupRead    : True
    UserExecute  : True
    UserWrite    : False
    UserRead     : True
    Sticky       : False
    SetGid       : False
    SetUid       : False
.NOTES
    Can only be used with File Uploads.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_filepermissions
#>
Function New-WinSCPFilePermissions
{
    [CmdletBinding()]
    [OutputType([WinSCP.FilePermissions])]

    Param
    (
        [Parameter()]
        [Switch]
        $GroupExecute,

        [Parameter()]
        [Switch]
        $GroupRead,

        [Parameter()]
        [Switch]
        $GroupWrite,

        [Parameter()]
        [Int]
        $Numeric,

        [Parameter()]
        [String]
        $Octal,

        [Parameter()]
        [Switch]
        $OtherExecute,

        [Parameter()]
        [Switch]
        $OtherRead,

        [Parameter()]
        [Switch]
        $OtherWrite,

        [Parameter()]
        [Switch]
        $SetGid,

        [Parameter()]
        [Switch]
        $SetUid,

        [Parameter()]
        [Switch]
        $Sticky,

        [Parameter()]
        [String]
        $Text,

        [Parameter()]
        [Switch]
        $UserExecute,

        [Parameter()]
        [Switch]
        $UserRead,

        [Parameter()]
        [Switch]
        $UserWrite
    )

    Begin
    {
        $filePermmisions = New-Object -TypeName WinSCP.FilePermissions

        foreach ($key in $PSBoundParameters.Keys)
        {
            try
            {
                $filePermmisions.$($key) = $PSBoundParameters.$($key)
            }
            catch [System.Exception]
            {
                Write-Error $_
            }
        }
    }

    End
    {
        return $filePermmisions
    }
}

<#
.SYNOPSIS
    Invokes a command on an Active WinSCP Session.
.DESCRIPTION
    Invokes a command on the system hosting the FTP/SFTP Service.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.CommandExecutionResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Command
    Command to execute.
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Invoke-WinSCPCommand -WinSCPSession $session -Command ("mysqldump --opt -u {0} --password={1} --all-databases | gzip > {2}" -f $dbUsername, $dbPassword, $tempFilePath)
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_executecommand
#>
Function Invoke-WinSCPCommand
{
    [CmdletBinding()]
    [OutputType([WinSCP.CommandExecutionResult])]

    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [String[]]
        $Command
    )

    Begin
    {
        if ($PSBoundParameters.ContainsKey('WinSCPSession'))
        {
            $valueFromPipeLine = $false
        }
        else
        {
            $valueFromPipeLine = $true
        }
    }

    Process
    {
        foreach ($commandment in $Command)
        {
            try
            {
                $WinSCPSession.ExecuteCommand($commandment)
            }
            catch [Exception]
            {
                Write-Error -Message $_
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}