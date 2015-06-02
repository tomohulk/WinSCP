<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER RemotePath
    Full path to remote directory followed by slash and wildcard to select files or subdirectories to download. When wildcard is omitted (path ends with slash), all files and subdirectories in the remote directory are downloaded.
.PARAMETER LocalPath
    Full path to download the file to. When downloading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with slash). 
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions. 
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -password 'FtpUserPword' -Protocol Ftp) | Receive-WinSCPItem -RemotePath './rDir/rFile.txt' -LocalPath 'C:\lDir\lFile.txt'

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -Username 'ftpuser' -password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    PS C:\> Receive-WinSCPItem -WinSCPSession $session -RemotePath './rDir/rFile.txt' -LocalPath 'C:\lDir\lFile.txt' -Remove

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_getfiles
#>
Function Receive-WinSCPItem
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOperationResult])]

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
        [String[]]
        $RemotePath,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $LocalPath = "$(Get-Location)\",

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $RemotePath.Replace('\','/'))
        {
            try
            {
                $WinSCPSession.GetFiles($item, $LocalPath, $Remove.IsPresent, $TransferOptions)
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