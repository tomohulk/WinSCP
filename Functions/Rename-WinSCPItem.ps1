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
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp) | Rename-WinSCPItem -Path './rDir/rFile.txt' -Destination './rDir/rNewFile.txt'
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    PS C:\> Rename-WinSCPItem -WinSCPSession $session -Path './rDir/rFile.txt' -Destination './rDir/rNewFile.txt'
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK 
    http://winscp.net/eng/docs/library_session_movefile
#>
Function Rename-WinSCPItem
{
    [CmdletBinding()]
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
        foreach ($item in $Path.Replace('\','/').TrimEnd('/'))
        {
            try
            {
                $newItemPath = $item.Replace($item.Substring($item.LastIndexOf('/') + 1), $NewName)

                Write-Verbose -Message "Performing the operation `"Rename WinSCPItem`" on target `"Item: $item Destination: $newItemPath`"."
                $WinSCPSession.MoveFile($item, $newItemPath)
            }
            catch [System.Exception]
            {
                Write-Error -ErrorRecord $_

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