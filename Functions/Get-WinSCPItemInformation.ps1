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
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_getfileinfo
#>
Function Get-WinSCPItemInformation
{
    [CmdletBinding()]
    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param
    (
        [Parameter(ValueFromPipeLine = $true,
                   Mandatory = $true)]
        [ValidateScript({ if ($_.Open) { return $true } else { throw 'The WinSCP Session is not in an Open state.' } })]
        [Alias('Session')]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $Path
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
                $WinSCPSession.GetFileInfo($item)
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