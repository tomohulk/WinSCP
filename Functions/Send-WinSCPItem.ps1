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
.PARAMETER Path
    Full path to local file or directory to upload. Filename in the path can be replaced with Windows wildcard to select multiple files. When file name is omitted (path ends with backslash), all files and subdirectories in the local directory are uploaded.
.PARAMETER Destination
    Full path to upload the file to. When uploading multiple files, the filename in the path should be replaced with ConvertTo-WinSCPEscapedString or omitted (path ends with slash). 
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-TransferOptions.
.PARAMETER Remove
    When present, deletes source local file(s) after transfer.
.EXAMPLE
    PS C:\> Open-WinSCPSession -SessionOptions (New-WinSCPSessionOptions -Hostname 'myftphost.org' -UserName 'ftpuser' -password 'FtpUserPword' -Protocol Ftp) | Send-WinSCPItem -Path 'C:\lDir\lFile.txt' -Destination './rDir/rFile.txt'
    
    Transfers           Failures IsSuccess
    ---------           -------- ---------
    {C:\lDir\lFile.txt} {}       True 
.EXAMPLE
    PS C:\> $session = New-WinSCPSessionOptions -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword; -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx' | Open-WinSCPSession
    PS C:\> Send-WinSCPItem -WinSCPSession $session -Path 'C:\lDir\lFile.txt' -Destination './rDir/rFile.txt' -Remove

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
        [ValidateScript({ if (Test-Path -Path $_)
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
        [String]
        $Destination = './',
        
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

        if (-not ($Path.EndsWith('/')))
        {
            $Path += '/'
        }
    }

    Process
    {
        foreach ($item in $Path)
        {
            try
            {
                $WinSCPSession.PutFiles($item, $Destination.Replace('\','/'), $Remove.IsPresent, $TransferOptions)
            }
            catch [System.Exception]
            {
                Write-Error -Message $_.ToString()
                
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