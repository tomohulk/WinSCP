<#
.SYNOPSIS
    Creates a new WinSCP Session
.DESCRIPTION
    Creates a new WINSCP.Session Object with specified Parameters.  Assign this Object to a Variable to easily manipulate actions later.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp
.NOTES
    Make sure to assign this as a variable so the session can be closed later with $session.Dispose()
.LINK
    http://dotps1.github.io
#>
function New-WinSCPSession
{
    [CmdletBinding()]
    [OutputType([WinSCP.Session])]

    param
    (
        # HostName, Type String, The FTP Host to connect to.
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [String]
        $HostName,

        # UserName, Type String, The Username to authenticate with when connecting to the FTP Host.
        [Parameter(Position = 1)]
        [String]
        $UserName,
        
        # Password, Type String, The Password to authenticate with when connecting to the FTP Host.
        [Parameter(Position = 2)]
        [String]
        $Password,

        # PortNumber, Type Int, The Port Number to connect to the FTP Host.
        # A value of 0 will use the Default Port based on the Protocol Used.
        [Parameter(Position = 3)]
        [Int]
        $PortNumber = 0,

        # Protocol, Type String, The Protocol to use when connecting to the FTP Host.
        [Parameter(Position = 4)]
        [ValidateSet("Sftp","Scp","Ftp")]
        [String]
        $Protocol = 'Sftp',

        # SshHostKeyFingerprint, Type String, The Certificate Fingerprint to use when connecting to the FTP Host.
        # This parameter is requried when using Sftp or Scp Protocols.
        [Parameter(Position = 5)]
        [String]
        $SshHostKeyFingerprint,

        # Timeout, Type Int, The amount of time, in seconds to wait for the FTP Host to respond.
        # Default Value is 15 Seconds.
        [Parameter(Position = 6)]
        [Int]
        $Timeout = 15
    )

    Begin
    {
        $sessionOptionsValues = @{
            'HostName' = $HostName
            'UserName' = $UserName
            'Password' = $Password
            'Protocol' = [WinSCP.Protocol]::$Protocol
            'PortNumber' = $PortNumber
            'Timeout' = [TimeSpan]::FromSeconds($Timeout)
        }

        if ($Protocol -eq 'Sftp' -or $Protocol -eq 'Scp')
        {
            if ([String]::IsNullOrEmpty($SshHostKeyFingerprint))
            {
                Write-Host "cmdlet New-WinSCPSession at command pipeline position 5"
                Write-Host "Supply values for the following parameter:"
                $SshHostKeyFingerprint = Read-Host -Prompt "SshHostKeyFingerprint"
            }
            $sessionOptionsValues.Add('SshHostKeyFingerprint',$SshHostKeyFingerprint)
        }

        $sessionOptions = New-Object -TypeName WinSCP.SessionOptions -Property $sessionOptionsValues
    }

    Process
    {
        try
        {
            $session = New-Object -TypeName WinSCP.Session
            $session.Open($sessionOptions)
        }
        catch
        {
            throw $Error[0].Exception.Message
        }
    }

    End
    {
        if ($session.Opened -eq $true)
        {
            return $session
        }
        else
        {
            Write-Error "Unable to open session to $HostName."
            return $null
        }
    }
}

<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Receive-WinSCPItem -WinSCPSession $session -RemoteItem "home/dir/myfile.txt" -LocalItem "C:\Dir\myfile.txt" -RemoveFromSource
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Receive-WinSCPItem -RemoteItem "home/dir/myfile.txt" -LocalItem "C:\Dir\myfile.txt"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of file download.
.LINK
    http://dotps1.github.io
#>
function Receive-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from New-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
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
            $WinSCPSession.GetFiles($item.Replace("\","/"), $LocalItem, $RemoveRemoteItem.IsPresent, $transferOptions)
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}

<#
.SYNOPSIS
    Send file(s) to an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to send file(s).
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Send-WinSCPItem -LocalItem "C:\Dir\myfile.txt" -Remote-Item "home/dir/myfile.txt"
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Send-WinSCPItem -LocalItem "C:\Dir\myfile.txt" -RemoteItem "home/dir/myfile.txt" 
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of file upload.
.LINK
    http://dotps1.github.io
#>
function Send-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from New-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
        [WinSCP.Session]
        $WinSCPSession,

        # LocalItem, Type String Array, The local location for the transfered item.
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [String[]]
        $LocalItem,

        # RemoteItem, Type String, The item to be transfered.
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
            $WinSCPSession.PutFiles($item, $RemoteItem.Replace("\","/"), $RemoveRemoteItem.IsPresent, $transferOptions)
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}

<#
.SYNOPSIS
    Creates a directory on an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to create new directory or nested directories.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; New-WinSCPDirectory -WinSCPSession $session -DirectoryName "home/MyDir/MyNewDir"
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | New-WinSCPDirectory -DirectoryName "MyDir/MyNewDir/MyNewSubDir"
.NOTES
   If the WinSCPSession is piped into this command, the connection will be disposed upon completion of file upload. 
.LINK
    http://dotps1.github.io
#>
function New-WinSCPDirectory
{
    [CmdletBinding()]
    [OutputType([Void])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from New-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
        [WinSCP.Session]
        $WinSCPSession,

        # DirectoryName, Type String Array, The path and name the new directory.
        # The working directory is set as the homepath on the FTP Host, all new directories will be made from that starting point.
        [Parameter(Mandatory = $true,
                   Position = 1)]
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
                Write-Output -InputObject "$DirectoryName created sucsesfully."
            }
            catch [WinSCP.SessionRemoteException]
            {
                Write-Error -Message $_ -Category InvalidArgument
                return
            }
            catch [WinSCP.SessionLocalException]
            {
                Write-Error -Message $_ -Category ConnectionError
                return
            }
            catch
            {
                Write-Error -Message "UnknownException"
                return
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}

<#
.SYNOPSIS
    Retrives information about a File or Directory from an active WinSCP Session.
.DESCRIPTION
    Retrives Name,FileType,Length,LastWriteTime,FilePermissions,IsDirectory Properties on an Item from an Active WinSCP Session.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Get-WinSCPItemInformation -WinSCPSession $session -RemoteItem "home/MyDir/MyNewDir"
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPItemInformation -RemoteItem "MyDir/MyNewDir/MyNewSubDir"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
#>
function Get-WinSCPItemInformation
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from New-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
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
            catch [WinSCP.SessionRemoteException]
            {
                Write-Error -Message $_ -Category InvalidArgument
                break
            }
            catch [WinSCP.SessionLocalException]
            {
                Write-Error -Message $_ -Category ConnectionError
                break
            }
            catch
            {
                Write-Error -Message "UnknownException"
                break
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}

<#
.SYNOPSIS
    Moves an item from one location to another from an active WinSCP Session.
.DESCRIPTION
    Once connected to an active WinSCP Session, one or many files can be moved to another location within the same WinSCP Session.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org" -Protocol Ftp; Move-WinSCPItem -WinSCPSession $session -SourceItem "home/MyDir/MyFile.txt" -DestinationItem "home/MyDir/MyNewDir/MyFile.txt"
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Move-WinSCPItem -SourceItem "MyDir/MyFile.txt" -DestinationItem "MyDir/MySubDir/MyFile.txt"
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io
#>
function Move-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([Void])]
    
    param
    (
        # WinSCPSession, Type WinSCP.Session, A valid open WinSCP.Session, returned from New-WinSCPSession.
        [Parameter(ValueFromPipeLine = $true,
                   Position = 0)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
        [WinSCP.Session]
        $WinSCPSession,

        [String[]]
        $SourceItem,

        [String]
        $DestinationItem
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
        foreach ($item in $SourceItem)
        {
            try
            {
                $WinSCPSession.MoveFile($item.Replace("\","/"), $DestinationItem)
                Write-Output -InputObject "$item moved sucssesfully."
            }
            catch [WinSCP.SessionRemoteException]
            {
                Write-Error -Message $_ -Category InvalidArgument
                break
            }
            catch [WinSCP.SessionLocalException]
            {
                Write-Error -Message $_ -Category ConnectionError
                break
            }
            catch
            {
                Write-Error -Message "UnknownException"
                break
            }
        }
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}