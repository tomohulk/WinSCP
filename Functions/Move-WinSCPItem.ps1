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
    http://dotps1.github.io/WinSCP
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
        [ValidateScript({ if ($_.Open) { return $true } else { throw 'The WinSCP Session is not in an Open state.' } })]
        [Alias('Session')]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [Alias('Source')]
        [String[]]
        $SourcePath,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [Alias('Target')]
        [String]
        $TargetPath
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $SourcePath.Replace('\','/'))
        {
            try
            {
                $filename = $item.Substring($item.LastIndexOf('/') + 1)
                $destination = $TargetPath.Replace('\','/')
                $WinSCPSession.MoveFile($item, $destination)
                if ($destination.EndsWith('/'))
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