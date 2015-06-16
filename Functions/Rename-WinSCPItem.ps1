<#
.SYNOPSIS
    Renames a remote item
.DESCRIPTION
    Renames a remote file or directory.  Be sure to include the file extension when renameing a file.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote item to be renamed.
.PARAMETER NewName
    The new name for the the item.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Rename-WinSCPItem -Path '/rDir/rFile.txt' -Destination '/rDir/rNewFile.txt'
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Rename-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination '/rDir/rNewFile.txt'
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK 
    http://winscp.net/eng/docs/library_session_movefile
#>
Function Rename-WinSCPItem
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

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $NewName
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

            try
            {
                $item = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $item
                $newItem = "$($item.Name.SubString(0, $item.Name.LastIndexOf('/') + 1))/$NewName"

                $WinSCPSession.MoveFile($item.Name, $newItemPath)
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