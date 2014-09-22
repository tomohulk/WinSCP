<#
.SYNOPSIS
    Defines information to allow an automatic connection and authentication of the session.
.DESCRIPTION
    This object with valid settings is requried when opening a connection to a remote server.
.EXAMPLE
    PS C:\> New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
.INPUTS
    None.
.OUTPUTS
    WinSCP.SessionOptions.
.NOTES
    If the Sftp/Scp protocols are used, a SshHostKeyFingerprint value is needed or the connection will fail.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_sessionoptions
#>
function New-WinSCPSessionOptions
{
    [CmdletBinding()]
    [OutputType([WinSCP.SessionOptions])]

    param
    (
        # HostName, Type String, The host to connect WinSCP to.
        [Parameter(Mandatory = $true)]
        [String]
        $HostName,

        # UserName, Type String, The Username to authenticate.
        [Parameter(Mandatory = $true)]
        [String]
        $UserName,

        # Password, Type String, The Password authenticate.
        [Parameter()]
        [String]
        $Password,

        # FtpMode, WinSCP.FtpMode, The mode of ftp to use.
        [Parameter()]
        [ValidateSet("Passive","Active")]
        [WinSCP.FtpMode]
        $FtpMode = "Passive",

        # FtpSecure, Type WinSCP.FtpSecure, the security type to use with SFTP.
        [Parameter()]
        [ValidateSet("None","Implicit","ExplicitTls","ExplicitSsl")]
        [WinSCP.FtpSecure]
        $FtpSecure = "None",

        # Protocol, Type WinSCP.Protocol, The protocol to  be used.
        [Parameter()]
        [ValidateSet("Sftp","Scp","Ftp")]
        [WinSCP.Protocol]
        $Protocol = "Sftp",

        # PortNumber, Type Int, The port to use, 0 will use the port default with protocol used.
        [Parameter()]
        [Int]
        $PortNumber = 0,

        # SshHostKeyFingerPrint, Type String, the Fingerprint of the SshHost to used, this property is mandatory when using Sftp or Scp protocols.
        [Parameter()]
        [String[]]
        $SshHostKeyFingerprint,
        
        # SshPrivateKeyPath, Type String, The full path to the private key.
        [Parameter()]
        [ValidateScript({ if (Test-Path -Path $_){ return $true } })]
        [String]
        $SshPrivateKeyPath,

        # TlsHostCertificateFingerprint, Type String, the Tls Certificate Fingerprint, use with Sftp.
        [Parameter()]
        [String]
        $TlsHostCertificateFingerprint,

        # Timeout, Type Int, The timeout in seconds for server response.  Default value is 15 seconds.
        [Parameter()]
        [Int]
        $Timeout = 15
    )

    $sessionOptions = New-Object -TypeName WinSCP.SessionOptions -Property @{
            FtpMode = $FtpMode
            FtpSecure = $FtpSecure
            HostName = $HostName
            Password = $Password
            PortNumber = $PortNumber
            Protocol = $Protocol
            Timeout = [TimeSpan]::FromSeconds($Timeout)
            UserName = $UserName
        }

    if ($Protocol -eq "Sftp" -or $Protocol -eq "Scp")
    {
        if ([String]::IsNullOrEmpty($SshHostKeyFingerprint))
        {
            Read-Host -Prompt "SshHostkeyFingerprint"
        }
    }

    if (-not([String]::IsNullOrEmpty($SshHostKeyFingerprint)))
    {
        try
        {
            $sessionOptions.SshHostKeyFingerprint = $SshHostKeyFingerprint
        }
        catch [System.Exception]
        {
            Write-Error $_
        }
    }

    if (-not([String]::IsNullOrEmpty($SshPrivateKeyPath)))
    {
        try 
        {
            $sessionOptions.SshPrivateKeyPath = $SshPrivateKeyPath
        }
        catch [System.Exception]
        {
            Write-Error $_
        }
    }

    if (-not([String]::IsNullOrEmpty($TlsHostCertificateFingerprint)))
    {
        try 
        {
            $sessionOptions.TlsHostCertificateFingerprint = $TlsHostCertificateFingerprint
        }
        catch [System.Exception]
        {
            Write-Error $_
        }
    }

    return $sessionOptions
}

<#
.SYNOPSIS
    This is the main interface class of the WinSCP assembly.
.DESCRIPTION
    Creates a new WINSCP.Session Object with setting specified in the WinSCP.SessionOptions object.  Assign this Object to a Variable to easily manipulate actions later.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp)
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp | Open-WinSCPSession
.NOTES
    If the WinSCPSession is piped into another WinSCP command, the connection will be disposed upon completion of that command.
.INPUTS
    WinSCP.SessionOptions.
.OUTPUTS
    WinSCP.Session.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session
#>
function Open-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([WinSCP.Session])]

    param
    (   
        # Defines information to allow an automatic connection and authentication of the session.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [WinSCP.SessionOptions]
        $SessionOptions,

        # Path to store session log file to. Default null means, no session log file is created.
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
.DISCRIPTION
    After a WinSCP Session is no longer needed this function will dispose the COM object.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Close-WinSCPSession
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Close-WinSCPSession -WinSCPSession $session
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.NOTES
    If the WinSCPSession is piped into another WinSCP command, this function will be called to auto dispose th connection upon complete of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session
#>
function Close-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([Void])]
    
    param
    (
        #WinSCPSession, Type WinSCP.Session, The active WinSCP Session to close.
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
    Sets options for file transfers.
.DESCRIPTION
    Sets available options for file transfers between the client and server.
.EXAMPLE
    PS C:\> New-WinSCPTransferOptions -PreserveTimeStamp -TransferMode Binary
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Receive-WinSCPItem -WinSCPSession $session -TransferOptions -RemoteItem "rDir/rFile.txt" -LocalItem "C:\lDir\lFile.txt" (New-WinSCPTransferOptions -PreserveTimeStamp -TransferMode Binary)
.INPUTS
    None.
.OUTPUTS
    WinSCP.TransferOptions.
.NOTES
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_transferoptions
#>
function New-WinSCPTransferOptions
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOptions])]

    param
    (
        # FileMask, Type String, The file mask to be used.
        [Parameter()]
        [String]
        $FileMask,

        # PreserveTimeStamp, Type Switch, Preserves the file created timestamp.
        [Parameter()]
        [Switch]
        $PreserveTimeStamp,

        # TransferMode, Type WinSCP.TransferMode, The method the file transfer use when transfering.
        [Parameter()]
        [ValidateSet("Binary","Ascii","Automatic")]
        [WinSCP.TransferMode]
        $TransferMode = "Binary"
    )

    $transferOptions = New-Object -TypeName WinSCP.TransferOptions -Property @{
        PreserveTimeStamp = $PreserveTimeStamp.IsPresent
        TransferMode = $TransferMode
    }

    return $transferOptions
}

<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Receive-WinSCPItem -RemoteItem "rDir/rFile.txt" -LocalItem "C:\lDir\lFile.txt"
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Receive-WinSCPItem -WinSCPSession $session -RemoteItem "rDir/rFile.txt" -LocalItem "C:\lDir\lFile.txt" -RemoveRemoteItem
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_getfiles
#>
function Receive-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The item to be transfered.
        [Parameter(Mandatory = $true)]
        [String[]]
        $RemoteItem,

        # LocalItem, Type String, The local location for the transfered item.  Default location is the current working directory.
        [Parameter()]
        [String]
        $LocalItem = "$(Get-Location)\",

        # TransferOptions, Type WinSCPtransferOption, The options for the file transfer.
        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = $(New-WinSCPTransferOptions),

        # RemoveRemoteItem, Type Switch, Remove the transfered files from the FTP Host upon completion.
        [Parameter()]
        [Switch]
        $RemoveRemoteItem
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
        foreach ($item in $RemoteItem.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.GetFiles($item, $LocalItem, $RemoveRemoteItem.IsPresent, $TransferOptions)
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
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Send-WinSCPItem -LocalItem "C:\lDir\lFile.txt" -RemoteItem "rDir/rFile.txt" 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Send-WinSCPItem -WinSCPSession $session -LocalItem "C:\lDir\lFile.txt" -RemoteItem "rDir/rFile.txt" -RemoveLocalItem
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_putfiles
#>
function Send-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # LocalItem, Type String Array, The local location for the item to be transfered.
        [Parameter(Mandatory = $true)]
        [String[]]
        $LocalItem,

        # RemoteItem, Type String, The item to be transfered to.  Default is the home directory for the user connecting.
        [Parameter()]
        [String]
        $RemoteItem = "./",
        
        # TransferOptions, Type WinSCPtransferOption, The options for the file transfer.
        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = $(New-WinSCPTransferOptions),

        # RemoveLocalItem, Type Switch, Remove the transfered files from the Local Host upon completion.
        [Parameter()]
        [Switch]
        $RemoveLocalItem
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
        foreach ($item in $LocalItem)
        {
            try
            {
                $WinSCPSession.PutFiles($item, $RemoteItem.Replace("\","/"), $RemoveRemoteItem.IsPresent, $TransferOptions)
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
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | New-WinSCPDirectory -DirectoryName "rDir/rSubDir" 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    New-WinSCPDirectory -WinSCPSession $session -DirectoryName "rDir/rSubDir"
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_createdirectory
#>
function New-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # DirectoryName, Type String Array, The path and name the new directory.  The working directory is set as the homepath on the FTP Host, all new directories will be made from that starting point.
        [Parameter(Mandatory = $true)]
        [Alias("Dir")]
        [String[]]
        $DirectoryName
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
        foreach($directory in $DirectoryName.Replace("\","/"))
        {
            try
            {
                $WinSCPSession.CreateDirectory($directory)
                return ($WinSCPSession.GetFileInfo($directory))
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
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Test-WinSCPItemExists -RemoteItem "rDir/rSubDir" 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Test-WinSCPItemExists -WinSCPSession $session -RemoteItem "rDir/rSubDir"
.INPUTS
    WinSCP.Session.
.OUTPUTS
    Boolean.
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_fileexists
#>
function Test-WinSCPItemExists
{
    [CmdletBinding()]
    [OutputType([Bool])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The full path to the item to be tested.
        [Parameter(Mandatory = $true)]
        [String[]]
        $RemoteItem
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
        foreach($item in $RemoteItem.Replace("\","/"))
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
    Retrives information about a File or Directory from an active WinSCP Session.
.DESCRIPTION
    Retreives Name,FileType,Length,LastWriteTime,FilePermissions,IsDirectory Properties on an Item from an Active WinSCP Session.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Get-WinSCPItemInformation -RemoteItem "rDir/rSubDir" 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Get-WinSCPItemInformation -WinSCPSession $session -RemoteItem "rDir/rSubDir"
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_getfileinfo
#>
function Get-WinSCPItemInformation
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The path of the item to get information.
        [Parameter(Mandatory = $true)]
        [String[]]
        $RemoteItem
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
        foreach ($item in $RemoteItem.Replace("\","/"))
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
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Get-WinSCPDirectoryContents -RemoteDirectory "rDir/rSubDir" 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Get-WinSCPDirectoryContents -WinSCPSession $session -RemoteDirectory "rDir/rSubDir" -ShowDetails
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteDirectoryInfo
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_listdirectory
#>
function Get-WinSCPDirectoryContents
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteDirectoryInfo])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteDirectory, Type String Array, The remote source path to show contents of.
        [Parameter(Mandatory = $true)]
        [Alias("Dir")]
        [String[]]
        $RemoteDirectory,

        # ShowDetails, Type Switch, Show details about each item.
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
        foreach ($directory in $RemoteDirectory.Replace("\","/"))
        {
            try
            {
                if ($ShowDetails.IsPresent)
                {
                    $WinSCPSession.ListDirectory($directory).Files
                }
                else
                {
                    $WinSCPSession.ListDirectory($directory)
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
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Move-WinSCPItem -RemoteSourceItem "rDir/rFile.txt" -RemoteDestinationItem rDir/rSubDir/rFile.txt 
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Move-WinSCPItem -WinSCPSession $session -RemoteSourceItem "rDir/rFile.txt" -RemoteDestinationItem rDir/rSubDir/rFile.txt
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.RemoteFileInfo
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK 
    http://winscp.net/eng/docs/library_session_movefile
#>
function Move-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteSourceItem, Type String Array, The remote source path of the item to be moved.
        [Parameter(Mandatory = $true)]
        [Alias("Source")]
        [String[]]
        $RemoteSourceItem,

        # RemoteDestinationItem, Type String, the remote destination for moving the items to.
        [Parameter(Mandatory = $true)]
        [Alias("Destination")]
        [String]
        $RemoteDestinationItem
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
        foreach ($item in $RemoteSourceItem.Replace("\","/"))
        {
            try
            {
                $filename = $item.Substring($item.LastIndexOf("/") + 1)
                $destination = $RemoteDestinationItem.Replace("\","/")
                $WinSCPSession.MoveFile($item, $destination)
                if ($destination.EndsWith("/"))
                {
                    return $WinSCPSession.GetFileInfo($destination+ $filename)
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
    Removes and item, File or Directory from a remote sources.  This action will recurse if a the $RemotePath value is a directory.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Remove-WinSCPItem -RemoteItem "rDir/rFile.txt"
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Remove-WinSCPItem -WinSCPSession $session -RemoteItem "rDir/rFile.txt"
.INPUTS
    WinSCP.Session
.OUTPUTS.
    WinSCP.RemovalOperationResult.
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_removefiles
#>
function Remove-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemovalOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The item to remove from the remote source.
        [Parameter(Mandatory = $true)]
        [String[]]
        $RemoteItem
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
        foreach ($item in $RemoteItem.Replace("\","/"))
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
    Syncronizes directories with an active WinSCP Session.
.DESCRIPTION
    Syncronizes a local directory with a remote directory, or vise versa.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Sync-WinSCPDirectory -RemoteDirectory "rDir/" -LocalDirectory "C:\lDir" -SyncMode Remote
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Sync-WinSCPDirectory -WinSCPSession $session -RemoteDirectory "rDir/" -LocalDirectory "C:\lDir" -SyncMode Remote
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.SynchronizationResult.
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_synchronizedirectories
#>
function Sync-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.SynchronizationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteDirectory, Type String, The remote source path to syncronize.
        [Parameter()]
        [String]
        $RemoteDirectory = "./",

        # LocalDirectory, Type String, The local source path to syncronize.  Default location is the current local working directory.
        [Parameter()]
        [String]
        $LocalDirectory = "$(Get-Location)\",

        # SyncMode, Type WinSCP.SynchronizationMode, The operation type to execute.
        [Parameter(Mandatory = $true)]
        [ValidateSet("Local","Remote","Both")]
        [WinSCP.SynchronizationMode]
        $SyncMode,

        # SyncCriteria, WinSCP.SynchronizationCriteria, The critera to base the sync on.  Default Value is Time.
        [Parameter()]
        [ValidateSet("None","Time","Size","Either")]
        [WinSCP.SynchronizationCriteria]
        $SyncCriteria = "Time",

        # Mirror, Type Switch, uses mirror mode. Cannot be used with SyncMode.Both.
        [Parameter()]
        [Switch]
        $Mirror,

        # TransferOptions, Type WinSCPtransferOption, The options for the file transfer.
        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = $(New-WinSCPTransferOptions),

        # RemoveFiles, Type Switch, removes obsolete files  Cannot be used with SyncMode.Both.
        [Parameter()]
        [Switch]
        $RemoveFiles
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
            $WinSCPSession.SynchronizeDirectories($SyncMode, $LocalDirectory.Replace("/","\"), $RemoteDirectory.Replace("\","/"), $RemoveFiles.IsPresent, $Mirror.IsPresent, $SyncCriteria, $TransferOptions)
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
    Invokes a command on an Active WinSCP Session.
.DESCRIPTION
    Invokes a command on the sytem hosting the FTP/SFTP Service.
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    Invoke-WinSCPCommand -WinSCPSession $session -Command ("mysqldump --opt -u {0} --password={1} --all-databases | gzip > {2}" -f $dbUsername, $dbPassword, $tempFilePath)
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.CommandExecutionResult.
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Invoke-WinSCPCommand
{
    [CmdletBinding()]
    [OutputType([WinSCP.CommandExecutionResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Open){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # Command, Type String Array, List of commands to send to the remote server.
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

<#
.SYNOPSIS
    Escapes special charcters in string.
.DESCRIPTION
    Escapes special charcters so they are not misinterpreted as wildcards or other special charcters.
.EXAMPLE
    $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    $searchString = ConvertTo-WinSCPEscapedString -String "*.txt"
    Receive-WinSCPItem -WinSCPSession $session -RemoteItem "./Dir/$searchString" -LocalItem "C:\lDir\"
.INPUTS
   None.
.OUTPUTS
    System.String. 
.NOTES
    Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.
.LINK
    http://dotps1.github.io
.LINK
    http://winscp.net/eng/docs/library_session_escapefilemask
#>
function ConvertTo-WinSCPEscapedString
{
    [CmdletBinding()]
    [OutputType([String])]

    param
    (
        # String, Type String , String to convert with special charcter escaping.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [String]
        $String
    )

    Begin
    {
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    Process
    {
        try
        {
            return ($sessionObject.EscapeFileMask($String))
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