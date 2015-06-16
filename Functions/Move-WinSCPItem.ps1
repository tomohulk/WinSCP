<#
.SYNOPSIS
    Moves an item from one location to another from an active WinSCP Session.
.DESCRIPTION
    Once connected to an active WinSCP Session, one or many files can be moved to another location within the same WinSCP Session.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote item to be moved.
.PARAMETER Destination
    Full path to new location to move the item to.
.PARAMETER Force
    Creates the destination directory if it does not exist.
.PARAMETER PassThru
    Returns a WinSCP.RemoteFileInfo of the moved object.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Move-WinSCPItem -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/'
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Move-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/'
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK 
    http://winscp.net/eng/docs/library_session_movefile
#>
Function Move-WinSCPItem
{
    [OutputType([Void])]
    
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
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $Path,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Destination = '/',

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $PassThru
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $Path)
        {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $item))
            {
                Write-Error -Message "Cannot find path: $item because it does not exist."

                continue
            }

            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $Destination))
            {
                if ($Force.IsPresent)
                {
                    $WinSCPSession.CreateDirectory($Destination)
                }
                else
                {
                    Write-Error -Message 'Could not find a part of the path.'

                    break
                }
            }

            try
            {
                $WinSCPSession.MoveFile($item, (Join-Path -Path $Destination -ChildPath (Split-Path -Path $item -Leaf)).Replace('\','/'))

                if ($PassThru.IsPresent)
                {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Join-Path -Path $Destination -ChildPath (Split-Path -Path $item -Leaf)).Replace('\','/')
                }
            }
            catch
            {
                Write-Error -Message $_.Exception.InnerException.Message
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