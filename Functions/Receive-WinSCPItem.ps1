<#
.SYNOPSIS
    Revices file(s) from an active WinSCP Session.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to receive file(s) and remove the remote files if desired.
.INPUTS
    WinSCP.Session.
    System.String.
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
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Receive-WinSCPItem -Path '/rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt'

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Receive-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination 'C:\lDir\lFile.txt' -Remove

    Transfers         Failures IsSuccess
    ---------         -------- ---------
    {/rDir/rFile.txt} {}       True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
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
                   ValueFromPipeline = $true)]
        [ValidateScript({ if ($_.Opened)
            { 
                return $true 
            }
            else
            { 
                throw 'The WinSCP Session is not in an Open state.' 
            } })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String[]]
        $Path,

        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Destination = $pwd,

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach ($p in (Format-WinSCPPathString -Path $($Path)))
        {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $p))
            {
                Write-Error -Message "Cannot find path: $p because it does not exist."

                continue
            }

            if (-not (Test-Path -Path $Destination))
            {
                Write-Error -Message "Cannot find path: $Destination because it does not exist."

                continue
            }

            if ((Get-Item -Path $Destination).Attributes -eq 'Directory' -and -not $Destination.EndsWith('\'))
            {
                $Destination += '\'
            }

            try
            {
                $WinSCPSession.GetFiles($p, $Destination, $Remove.IsPresent, $TransferOptions)
            }
            catch 
            {
                Write-Error -Message $_.ToString()
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