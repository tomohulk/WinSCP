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
    http://dotps1.github.io/WinSCP
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
        [ValidateScript({ if($_.Open){ return $true }else{ throw 'The WinSCP Session is not in an Open state.' } })]
        [Alias('Session')]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [Alias('Dir')]
        [String[]]
        $Path,

        [Parameter()]
        [Switch]
        $ShowDetails
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $Path.Replace('\','/'))
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

                continue
            }
        }
    }

    End
    {
        if (-not ($sessionValueFromPipeLine))
        {
            Close-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}