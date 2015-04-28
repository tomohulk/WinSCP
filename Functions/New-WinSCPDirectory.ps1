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
    http://dotps1.github.io/WinSCP
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
        [ValidateScript({ if ($_.Open) { return $true } else { throw 'The WinSCP Session is not in an Open state.' } })]
        [Alias('Session')]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [Alias('Dir')]
        [String[]]
        $Path
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach($item in $Path.Replace('\','/'))
        {
            try
            {
                $WinSCPSession.CreateDirectory($item)
                return ($WinSCPSession.GetFileInfo($item))
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