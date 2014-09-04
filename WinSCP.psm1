<#
.SYNOPSIS
    Creates a new WinSCP Session
.DESCRIPTION
    Creates a new WINSCP.Session Object with specified Parameters.  Assign this Object to a Variable to easily manipulate actions later.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" -Protocol Ftp
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org"
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
        [Parameter(Mandatory = $true)]
        [String]
        $HostName,

        [String]
        $UserName,
        
        [String]
        $Password,

        [String]
        $SshHostKeyFingerprint,

        [ValidateSet("Sftp","Scp","Ftp")]
        [String]
        $Protocol = 'Sftp',

        [Int]
        $PortNumber = 0,

        [int]
        $Timeout = 15
    )

    $sessionOptions = @{
        'HostName' = $HostName
        'UserName' = $UserName
        'Password' = $Password
        'Protocol' = [WinSCP.Protocol]::$Protocol
        'SshHostKeyFingerprint' = $SshHostKeyFingerprint
        'PortNumber' = $PortNumber
        'Timeout' = [TimeSpan]::FromSeconds($Timeout)
    }
    if ([String]::IsNullOrEmpty($SshHostKeyFingerprint))
    {
        $sessionOptions.Remove('SshHostKeyFingerprint')
    }

    try
    {
        $session = New-Object -TypeName WinSCP.Session
        $session.Open($(New-Object -TypeName WinSCP.SessionOptions -Property $sessionOptions))
        return $session
    }
    catch
    {
        throw "Unable to open session to $HostName."
    }
}

<#
.SYNOPSIS
    Downloads file(s) from active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to download file(s) and remove the remote files if desired.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org";  Get-WinSCPFiles -WinSCPSession $session -RemoteFiles "home/dir/myfile.txt"
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPFiles -RemoteFiles "home/dir/myfile.txt"
.NOTES
    if the WinSCPSession is piped into this command, the connection will be disposed upon completion of file download.
.LINK
    http://dotps1.github.io
#>
function Get-WinSCPFiles
{
    [CmdletBinding()]

    param
    (
        [Parameter(ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
        [WinSCP.Session]
        $WinSCPSession,

        [Bool]
        $RemoveRemoteFile = $false,

        [ValidateSet("Binary","Ascii","Automatic")]
        [String]
        $TransferMode = "Automatic",

        [Bool]
        $PreserveTimeStamp = $true,

        [Parameter(ParameterSetName = "Directories")]
        [String]
        $RemoteDirectory,

        [Parameter(ParameterSetName = "Directories",
                   Mandatory = $true)]
        [String]
        $LocalDirectory,

        [Parameter(ParameterSetName = "Files")]
        [String]
        $RemoteFile,

        [Parameter(ParameterSetName = "Files",
                   Mandatory = $true)]
        [String]
        $LocalFile
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
        $transferResult = $WinSCPSession.GetFiles($RemoteFile, $LocalFile, $false, $transferOptions).IsSuccess
        Write-Output $transferResult
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}