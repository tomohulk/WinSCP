<#
.SYNOPSIS
    Test if a remote item exists.
.DESCRIPTION
    After creating a valid WinSCP Session, this function can be used to test if a directory or file exists on the remote source.
.INPUTS
    WinSCP.Session.
    System.String
.OUTPUTS
    System.Boolean.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from Open-WinSCPSession.
.PARAMETER Path
    Full path to remote file.
.EXAMPLE
    PS C:\> New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -Protocol Ftp | Test-WinSCPPath -Path '/rDir/rSubDir'

    True
.EXAMPLE
    PS C:\> $session = New-WinSCPSession -Hostname 'myftphost.org' -UserName 'ftpuser' -Password 'FtpUserPword' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Test-WinSCPPath -WinSCPSession $session -Path '/rDir/rSubDir'

    True
.NOTES
   If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_fileexists
#>
Function Test-WinSCPPath
{
    [OutputType([Bool])]
    
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
        $Path
    )

    Begin
    {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process
    {
        foreach($p in (Format-WinSCPPathString -Path $($Path)))
        {
            try
            {
                $WinSCPSession.FileExists($p)
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