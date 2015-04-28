<#
.SYNOPSIS
    Send file(s) to an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to send file(s).
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.TransferOperationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER LocalPath
    Full path to local file or directory to upload. Filename in the path can be replaced with Windows wildcard to select multiple files. When file name is omitted (path ends with backslash), all files and subdirectories in the local directory are uploaded.
.PARAMETER RemotePath
    Full path to upload the file to. When uploading multiple files, the filename in the path should be replaced with ConvertTo-WinSCPEscapedString or omitted (path ends with slash). 
.PARAMETER Remove
    When present, deletes source local file(s) after transfer.
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -Protocol Ftp) | Send-WinSCPItem -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt"
    
    Transfers           Failures IsSuccess
    ---------           -------- ---------
    {C:\lDir\lFile.txt} {}       True 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname myftphost.org -Username ftpuser -password "FtpUserPword" -SshHostKeyFingerprint "ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx" | Open-WinSCPSession
    PS C:\> Send-WinSCPItem -WinSCPSession $session -LocalPath "C:\lDir\lFile.txt" -RemotePath "rDir/rFile.txt" -Remove

    Transfers           Failures IsSuccess
    ---------           -------- ---------
    {C:\lDir\lFile.txt} {}       True 
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_putfiles
#>
Function Send-WinSCPItem
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
        $LocalPath,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $RemotePath = './',
        
        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions,

        [Parameter()]
        [Switch]
        $Remove
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($item in $LocalPath)
        {
            try
            {
                $WinSCPSession.PutFiles($item, $RemotePath.Replace('\','/'), $Remove.IsPresent, $TransferOptions)
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