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
.PARAMETER Path
    Full path to remote directory followed by slash and wildcard to select files or subdirectories to download. When wildcard is omitted (path ends with slash), all files and subdirectories in the remote directory are downloaded.
.PARAMETER Destination
    Full path to download the file to. When downloading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with slash). 
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions. 
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Receive-WinSCPItem -Path './rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt'

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Receive-WinSCPItem -WinSCPSession $session -Path './rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt' -Remove

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
    [OutputType([WinSCP.TransferOperationResult])]

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
        $Path,

        [Parameter()]
        [ValidateScript({ if (Test-Path -Path $_)
            {
                return $true
            }
            else
            {
                throw "Cannot find the file specified $_."
            } })]
        [String]
        $Destination = "$(Get-Location)\",

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-WinSCPTransferOptions)
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
                $WinSCPSession.GetFiles($item, $Destination, $Remove.IsPresent, $TransferOptions)
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