<#
.SYNOPSIS
    Creates a new WinSCP Session
.DESCRIPTION
    Creates a new WINSCP.Session Object with specified Parameters.  Assign this Object to a Variable to easily manipulate actions later.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
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
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [String]
        $HostName,

        [Parameter(Position = 1)]
        [String]
        $UserName,
        
        [Parameter(Position = 2)]
        [String]
        $Password,

        [Parameter(Position = 3)]
        [Int]
        $PortNumber = 0,

        [Parameter(Position = 4)]
        [ValidateSet("Sftp","Scp","Ftp")]
        [String]
        $Protocol = 'Sftp',

        [Parameter(Position = 5)]
        [String]
        $SshHostKeyFingerprint,

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
        if ($Protocol -eq 'Sftp' -or $Protocol -eq 'Scp' )
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
    Downloads file(s) from active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to download file(s) and remove the remote files if desired.
.EXAMPLE
    $session = New-WinSCPSession -HostName "myinsecurehost.org";  Get-WinSCPItems -WinSCPSession $session -RemoteFile "home/dir/myfile.txt" -LocalFile "C:\Dir\myfile.txt" -RemoveFromSource
.EXAMPLE
    New-WinSCPSession -HostName "myhost.org" -UserName "username" -Password "123456789" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Get-WinSCPItems -RemoteFile "home/dir/myfile.txt" -LocalFile "C:\Dir\myfile.txt"
.NOTES
    if the WinSCPSession is piped into this command, the connection will be disposed upon completion of file download.
.LINK
    http://dotps1.github.io
#>
function Get-WinSCPItems
{
    [CmdletBinding()]

    param
    (
        [Parameter(ValueFromPipeLine = $true)]
        [ValidateScript({ if($_.Opened -eq $true){ return $true }else{ throw "No active WinSCP Session." } })]
        [WinSCP.Session]
        $WinSCPSession,

        [Switch]
        $RemoveFromSource,

        [ValidateSet("Binary","Ascii","Automatic")]
        [String]
        $TransferMode = "Automatic",

        [Switch]
        $PreserveTimeStamp,

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
            PreserveTimestamp = $PreserveTimeStamp.IsPresent
        }
    }

    Process
    {
        if ($PSCmdlet.ParameterSetName -eq "Directories")
        {
            if (-not($RemoteDirectory.EndsWith("/*")))
            {
                $RemoteDirectory += "/*"
            }
            elseif (-not($RemoteDirectory.EndsWith("*")))
            {
                $RemoteDirectory += "*"
            }

            $transferResult = $WinSCPSession.GetFiles($RemoteDirectory, $LocalDirectory, $RemoveFromSource.IsPresent, $transferOptions).IsSuccess
        }

        if ($PSCmdlet.ParameterSetName -eq "Files")
        {
            if ($WinSCPSession.FileExists($RemoteFile))
            {
                $transferResult = $WinSCPSession.GetFiles($RemoteFile, $LocalFile, $RemoveFromSource.IsPresent, $transferOptions).IsSuccess
            }
            else
            {
                Write-Error -Message "FileNotFound: $RemoteFile" -Category ObjectNotFound -RecommendedAction "Verfiy the RemoteFile Parameter Value." -ErrorAction Stop
            }
        }

        Write-Output "Transfer Result: $transferResult"
    }

    End
    {
        if ($valueFromPipeLine -eq $true)
        {
            $WinSCPSession.Dispose()
        }
    }
}