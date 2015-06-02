<#
.SYNOPSIS
    Synchronizes directories with an active WinSCP Session.
.DESCRIPTION
    Synchronizes a local directory with a remote directory, or vise versa.
.INPUTS
    WinSCP.Session.
.OUTPUTS
    WinSCP.SynchronizationResult.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Mode
    Synchronization mode. Possible values are Local, Remote and Both. 
.PARAMETER LocalPath
    Full path to local directory.
.PARAMETER RemotePath
    Full path to remote directory.
.PARAMETER Remove
    When used, deletes obsolete files. Cannot be used with -Mode Both.
.PARAMETER Mirror
    When used, synchronizes in mirror mode (synchronizes also older files). Cannot be used for -Mode Both.
.PARAMETER Criteria
    Comparison criteria. Possible values are None, Time (default), .Size and Either. For -Mode Both Time can be used only.
.PARAMETER TransferOptions
    Transfer options. Defaults to null, what is equivalent to New-WinSCPTransferOptions. 
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Sync-WinSCPDirectory -RemotePath "./" -LocalPath "C:\lDir\" -Mode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Sync-WinSCPDirectory -WinSCPSession $session -RemotePath './' -LocalPath 'C:\lDir\' -SyncMode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_synchronizedirectories
#>
Function Sync-WinSCPDirectory
{
    [OutputType([WinSCP.SynchronizationResult])]

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
        [WinSCP.SynchronizationMode]
        $Mode,

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
        $LocalPath = "$(Get-Location)\",

        [Parameter()]
        [ValidateScript({ if (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $_) 
            {
                return $true
            }
            else
            {
                throw "Cannot find the file specified $_."
            } })]
        [String]
        $RemotePath = './',

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [Switch]
        $Mirror,

        [Parameter()]
        [WinSCP.SynchronizationCriteria]
        $Criteria = [WinSCP.SynchronizationCriteria]::Time,

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
        try
        {
            $WinSCPSession.SynchronizeDirectories($Mode, $LocalPath.Replace('/','\'), $RemotePath.Replace('\','/'), $Remove.IsPresent, $Mirror.IsPresent, $Criteria, $TransferOptions)
        }
        catch [System.Exception]
        {
            throw $_
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