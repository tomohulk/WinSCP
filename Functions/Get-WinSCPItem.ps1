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
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Get-WinSCPItem -Path './rDir/rSubDir'
    
    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Get-WinSCPItem -WinSCPSession $session -Path './rDir/rSubDir'

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_getfileinfo
#>
Function Get-WinSCPItem
{
    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeLine = $true)]
        [ValidateScript({ if ($_.Open)
            { 
                return $true 
            }
            else
            { 
                throw 'The WinSCP Session is not in an Open state.' 
            } })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ if (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $_)
            {
                return $true
            }
            else
            {
                throw "Cannot find the file specified $_."
            } })]
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
            if (-not ($item.EndsWith('/')))
            {
                $item += '/'
            }

            try
            {
                $WinSCPSession.GetFileInfo($item)
            }
            catch [System.Exception]
            {
                throw $_
            }
        }
    }

    End
    {
        if (-not ($sessionValueFromPipeLine))
        {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}