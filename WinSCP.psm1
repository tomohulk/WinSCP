<#
.SYNOPSIS
    Creates a new WinSCP Session.
.DESCRIPTION
    Creates a new WINSCP.Session Object with specified Parameters.  Assign this Object to a Variable to easily manipulate actions later.
.EXAMPLE
    $session = Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
.EXAMPLE
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp
.NOTES
    If the WinSCPSession is piped into another WinSCP command, the connection will be disposed upon completion of that command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Open-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([WinSCP.Session])]

    param
    (
        # HostName, Type String, The FTP Host to connect to.
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [Alias("Host","Server")]
        [String]
        $HostName,

        # Username, Type String, The Username to authenticate with when connecting to the FTP Host.
        [Parameter(Position = 1)]
        [String]
        $Username,
        
        # Password, Type String, The Password to authenticate with when connecting to the FTP Host.
        [Parameter(Position = 2)]
        [String]
        $Password,

        # PortNumber, Type Int, The Port Number to connect to the FTP Host.
        # A value of 0 will use the Default Port based on the Protocol Used.
        [Parameter(Position = 3)]
        [Alias("Port")]
        [Int]
        $PortNumber = 0,

        # Protocol, Type String, The Protocol to use when connecting to the remot host.
        [Parameter(Position = 4)]
        [ValidateSet("Sftp","Scp","Ftp")]
        [String]
        $Protocol = "Sftp",

        # FtpMode, Type String, The Mode type to use when connecting to a remote host.
        # Default Value is Passive.
        [Parameter(Position = 5)]
        [ValidateSet("Passive","Active")]
        [String]
        $FtpMode = "Passive",

        # FtpSecurity, Type String, The Protocal Security to use with secure transfers.
        # Default value is None.
        [Parameter(Position = 6)]
        [ValidateSet("None","Implicit","ExplicitTls","ExplicitSsl")]
        [String]
        $FtpSecurity = "None",

        # SshHostKeyFingerprint, Type String, The Certificate Fingerprint to use when connecting to the FTP Host.
        # This parameter is requried when using Sftp or Scp Protocols.
        [Parameter(Position = 7)]
        [Alias("Key")]
        [String]
        $SshHostKeyFingerprint,

        # Timeout, Type Int, The amount of time, in seconds to wait for the Remote Host to respond.
        # Default Value is 15 Seconds.
        [Parameter(Position = 8)]
        [Int]
        $Timeout = 15,

        # SessionLogPath, Type String, Full path to create a session log.
        # Default Value is $null or no log.
        [Parameter(Position = 9)]
        $SessionLogPath = $null
    )

    Begin
    {
        $sessionOptions = @{
            'HostName'   = $HostName
            'Username'   = $Username
            'Password'   = $Password
            'Protocol'   = [WinSCP.Protocol]::$Protocol
            'FtpMode'    = [WinSCP.FtpMode]::$FtpMode
            'FtpSecure'  = [WinSCP.FtpSecure]::$FtpSecurity
            'PortNumber' = $PortNumber
            'Timeout'    = [TimeSpan]::FromSeconds($Timeout)

        }

        if ($Protocol -eq 'Sftp' -or $Protocol -eq 'Scp')
        {
            if ([String]::IsNullOrEmpty($SshHostKeyFingerprint))
            {
                Write-Host "cmdlet Open-WinSCPSession at command pipeline position 7"
                Write-Host "Supply values for the following parameter:"
                $SshHostKeyFingerprint = Read-Host -Prompt "SshHostKeyFingerprint"
            }

            $sessionOptions.Add('SshHostKeyFingerprint',$SshHostKeyFingerprint)
        }
    }

    Process
    {
        try
        {
            $session = New-Object -TypeName WinSCP.Session
            $session.SessionLogPath = $SessionLogPath
            $session.Open($sessionOptions)
            return $session
        }
        catch [System.Exception]
        {
            Write-Error $_
            return
        }
    }
}

<#
.SYNOPSIS
    Test if a WinSCP Session is in an Open State.
.DESCRIPTION
    Verifys that the WinSCP Session is in an open state so commands can be sent to a remote server.
.EXAMPLE
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Test-WinSCPSession -WinSCPSession $session
.NOTES
    This function is used in the Begin Statement of subsequent functions to verify the connection to the remote server is open.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Test-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([Bool])]

    param
    (
        #WinSCPSession, Type WinSCP.Session, The active WinSCP Session to close.
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession
    )

    if ($WinSCPSession.Opened)
    {
        return $true
    }
    else
    {
        return $false
    }
}

<#
.SYNOPSIS
    Closes an active WinSCP Session.
.DISCRIPTION
    After a WinSCP Session is no longer needed this function will dispose the COM object.
.EXAMPLE
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Close-WinSCPSession -WinSCPSession $session
.NOTES
    If the WinSCPSession is piped into another WinSCP command, this function will be called to auto dispose th connection upon complete of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Close-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([Void])]
    
    param
    (
        #WinSCPSession, Type WinSCP.Session, The active WinSCP Session to close.
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession
    )

    if (Test-WinSCPSession -WinSCPSession $WinSCPSession)
    {
        $WinSCPSession.Dispose()
    }
}

<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.EXAMPLE
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Receive-WinSCPItem -WinSCPSession $session -RemoteItem "home/dir/myfile.txt" -LocalItem "C:\Dir\myfile.txt" -RemoveFromSource
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Receive-WinSCPItem -RemoteItem "home/dir/myfile.txt" -LocalItem "C:\Dir\myfile.txt"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Receive-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The item to be transfered.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [String[]]
        $RemoteItem,

        # LocalItem, Type String, The local location for the transfered item.
        # Default location is the current working directory.
        [Parameter(Position = 2)]
        [String]
        $LocalItem = "$(Get-Location)\",

        # TransferMode, Type String, The transfer method to be used when transfering files.
        [Parameter(Position = 3)]
        [ValidateSet("Binary","Ascii","Automatic")]
        [String]
        $TransferMode = "Automatic",

        # PreserveTimeStamp, Type Bool, Set the file created time as the time from the FTP Host, or set the created time to the current time.
        # Default Value is True.
        [Parameter(Position = 4)]
        [Bool]
        $PreserveTimeStamp = $true,

        # RemoveRemoteItem, Type Switch, Remove the transfered files from the FTP Host upon completion.
        [Parameter(Position = 5)]
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

        $transferOptions = @{
            TransferMode = [WinSCP.TransferMode]::$TransferMode
            PreserveTimestamp = $PreserveTimeStamp
        }
    }

    Process
    {
        foreach ($item in $RemoteItem)
        {
            try
            {
                $WinSCPSession.GetFiles($item.Replace("\","/"), $LocalItem, $RemoveRemoteItem.IsPresent, $transferOptions)
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Send-WinSCPItem -WinSCPSession $session -LocalItem "C:\Dir\myfile.txt" -Remote-Item "home/dir/myfile.txt"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Send-WinSCPItem -LocalItem "C:\Dir\myfile.txt" -RemoteItem "home/dir/myfile.txt" 
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Send-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # LocalItem, Type String Array, The local location for the item to be transfered.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [String[]]
        $LocalItem,

        # RemoteItem, Type String, The item to be transfered to.
        [Parameter(Mandatory = $true,
                   Position = 2)]
        [String]
        $RemoteItem,
        
        # TransferMode, Type String, The transfer method to be used when transfering files.
        [Parameter(Position = 3)]
        [ValidateSet("Binary","Ascii","Automatic")]
        [String]
        $TransferMode = "Automatic",

        # PreserveTimeStamp, Type Bool, Set the file created time as the time from the FTP Host, or set the created time to the current time.
        # Default Value is True.
        [Parameter(Position = 4)]
        [Bool]
        $PreserveTimeStamp = $true,

        # RemoveLocalItem, Type Switch, Remove the transfered files from the Local Host upon completion.
        [Parameter(Position = 5)]
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

        $transferOptions = @{
            TransferMode = [WinSCP.TransferMode]::$TransferMode
            PreserveTimestamp = $PreserveTimeStamp
        }
    }

    Process
    {
        foreach ($item in $LocalItem)
        {
            try
            {
                $WinSCPSession.PutFiles($item, $RemoteItem.Replace("\","/"), $RemoveRemoteItem.IsPresent, $transferOptions)
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; New-WinSCPDirectory -WinSCPSession $session -DirectoryName "home/MyDir/MyNewDir"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | New-WinSCPDirectory -DirectoryName "MyDir/MyNewDir/MyNewSubDir"
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function New-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # DirectoryName, Type String Array, The path and name the new directory.
        # The working directory is set as the homepath on the FTP Host, all new directories will be made from that starting point.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
        foreach($directory in $DirectoryName)
        {
            try
            {
                $WinSCPSession.CreateDirectory($directory.Replace("\","/"))
                return ($WinSCPSession.GetFileInfo($directory.Replace("\","/")))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Test-WinSCPItemExists -WinSCPSession $session -RemoteItem "home/MyDir/MyNewDir"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Test-WinSCPItemExists -RemoteItem "MyDir/MyNewDir/MyNewSubDir/MyFile.txt"
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Test-WinSCPItemExists
{
    [CmdletBinding()]
    [OutputType([Bool])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The full path to the item to be tested.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
        foreach($item in $RemoteItem)
        {
            try
            {
                $WinSCPSession.FileExists($item.Replace("\","/"))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Get-WinSCPItemInformation -WinSCPSession $session -RemoteItem "home/MyDir/MyNewDir/MyFile.txt"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPItemInformation -RemoteItem "MyDir/MyNewDir/MyNewSubDir"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Get-WinSCPItemInformation
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The path of the item to get information.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
        foreach ($item in $RemoteItem)
        {
            try
            {
                $WinSCPSession.GetFileInfo($item.Replace("\","/"))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Get-WinSCPDirectoryContents -WinSCPSession $session -RemoteDirectory "home/MyDir/"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPDirectoryContents -RemoteDirectory "home/MyDir/" -ShowDetails
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Get-WinSCPDirectoryContents
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteDirectoryInfo])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteDirectory, Type String Array, The remote source path to show contents of.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [Alias("Dir")]
        [String[]]
        $RemoteDirectory,

        # ShowDetails, Type Switch, Show details about each item.
        [Parameter(Position = 3)]
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
        foreach ($directory in $RemoteDirectory)
        {
            try
            {
                if ($ShowDetails.IsPresent)
                {
                    $WinSCPSession.ListDirectory($directory.Replace("\","/")).Files
                }
                else
                {
                    $WinSCPSession.ListDirectory($directory.Replace("\","/"))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Move-WinSCPItem -WinSCPSession $session -SourceItem "home/MyDir/MyFile.txt" -DestinationItem "home/MyDir/MyNewDir/MyFile.txt"
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Move-WinSCPItem -SourceItem "MyDir/MyFile.txt" -DestinationItem "MyDir/MySubDir/MyFile.txt"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Move-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteSourceItem, Type String Array, The remote source path of the item to be moved.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [Alias("Source")]
        [String[]]
        $RemoteSourceItem,

        # RemoteDestinationItem, Type String, the remote destination for moving the items to.
        [Parameter(Mandatory = $true,
                   Position = 2)]
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
        foreach ($item in $RemoteSourceItem)
        {
            try
            {
                $WinSCPSession.MoveFile($item.Replace("\","/"), $RemoteDestinationItem.Replace("\","/"))
                return ($WinSCPSession.GetFileInfo($RemoteDestinationItem.Replace("\","/")))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Remove-WinSCPItem -WinSCPSession $session -RemoteItem "home/MyDir/MyFile.txt" -LocalDirectory "C:\Dir\" -SyncMode
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Remove-WinSCPItem -RemoteItem "MyDir/MySubDir"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Remove-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemovalOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteItem, Type String Array, The item to remove from the remote source.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
        foreach ($item in $RemoteItem)
        {
            try
            {
                $WinSCPSession.RemoveFiles($item.Replace("\","/"))
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Sync-WinSCPDirectory -WinSCPSession $session -RemoteDirectory "home/MyDir/" -LocalDirectory "C:\MyDir" -SyncMode Local
.EXAMPLE
    Open-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Sync-WinSCPDirectory -RemoteDirectory "MyDir/MySubDir" -LocalDirectory "C:\Mydir\MySubDir" -SyncMode Both
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
    http://winscp.net
#>
function Sync-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([WinSCP.SynchronizationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from Open-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # RemoteDirectory, Type String, The remote source path to syncronize.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [String]
        $RemoteDirectory,

        # LocalDirectory, Type String, The local source path to syncronize.
        # Default location is the current local working directory.
        [Parameter(Position = 2)]
        [String]
        $LocalDirectory = "$(Get-Location)\",

        # SyncMode, Type String, The operation type to execute.
        [Parameter(Mandatory = $true,
                   Position = 3)]
        [ValidateSet("Local","Remote","Both")]
        [String]
        $SyncMode,

        # SyncCriteria, Type String, The critera to base the sync on.
        # Default Value is Time.
        [Parameter(Position = 4)]
        [ValidateSet("None","Time","Size","Either")]
        [String]
        $SyncCriteria = "Time",

        # Mirror, Type Switch, uses mirror mode.
        # Cannot be used with SyncMode.Both.
        [Parameter(Position = 5)]
        [Switch]
        $Mirror,

        # TransferMode, Type String, The transfer method to be used when transfering files.
        # Default Value is Automatic.
        [Parameter(Position = 6)]
        [ValidateSet("Binary","Ascii","Automatic")]
        [String]
        $TransferMode = "Automatic",

        # PreserveTimeStamp, Type Bool, Set the file created time as the time from source, or set the created time to the current time.
        # Default Value is True.
        [Parameter(Position = 7)]
        [Bool]
        $PreserveTimeStamp = $true,

        # RemoveFiles, Type Switch, removes obsolete files.
        # Cannot be used with SyncMode.Both.
        [Parameter(Position = 8)]
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

        $transferOptions = @{
            TransferMode = [WinSCP.TransferMode]::$TransferMode
            PreserveTimestamp = $PreserveTimeStamp
        }
    }

    Process
    {
        try
        {
            $WinSCPSession.SynchronizeDirectories([WinSCP.SynchronizationMode]::$SyncMode, $LocalDirectory.Replace("/","\"), $RemoteDirectory.Replace("\","/"), $RemoveFiles.IsPresent, $Mirror.IsPresent, [WinSCP.SynchronizationCriteria]::$SyncCriteria, $transferOptions)
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Invoke-WinSCPCommand -WinSCPSession $session -Command ("mysqldump --opt -u {0} --password={1} --all-databases | gzip > {2}" -f $dbUsername, $dbPassword, $tempFilePath)
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
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if(Test-WinSCPSession -WinSCPSession $_){ return $true }else{ throw "The WinSCP Session is not in an Open state." } })]
        [Alias("Session")]
        [WinSCP.Session]
        $WinSCPSession,

        # Command, Type String Array, List of commands to send to the remote server.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
    $session = Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Receive-WinSCPItem -WinSCPSession $session -RemoteItem (ConvertTo-WinSCPEscapedString -String "dir/filewithstar*.txt") -LocalItem "C:\Dir\"
.EXAMPLE
    $searchString = ConvertTo-WinSCPEscapedString -String "*.txt"; Open-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp | Get-WinSCPItemInformation -RemoteItem "Dir/SubDir/$searchString
.NOTES
    Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.
.LINK
    http://dotps1.github.io
    http://winscp.net
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

    try
    {
        $sessionObject = New-Object WinSCP.Session
        return ($sessionObject.EscapeFileMask($String))
        $sessionObject.Dispose()
    }
    catch [System.Exception]
    {
        Write-Error $_
        return
    }
}