<#
.SYNOPSIS
    Moves an item from one location to another from an active WinSCP Session.
.DESCRIPTION
    Once connected to an active WinSCP Session, one or many files can be moved to another location within the same WinSCP Session.
.INPUTS
    WinSCP.Session.
    System.String.
.OUTPUTS
    None.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from New-WinSCPSession.
.PARAMETER Path
    Full path to remote item to be moved.
.PARAMETER Destination
    Full path to new location to move the item to.
.PARAMETER Force
    Creates the destination directory if it does not exist.
.PARAMETER PassThru
    Returns a WinSCP.RemoteFileInfo of the moved object.
.EXAMPLE
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Move-WinSCPItem -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/'
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Move-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination '/rDir/rSubDir/'
.NOTES
    If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
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
        if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path ($Destination = Format-WinSCPPathString -Path $($Destination))))
        {
            if ($Force.IsPresent)
            {
                New-WinSCPItem -WinSCPSession $WinSCPSession -Path $Destination -ItemType Directory
            }
            else
            {
                Write-Error -Message 'Could not find a part of the path.'

                return
            }
        }

        foreach ($p in (Format-WinSCPPathString -Path $($Path)))
        {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $p))
            {
                Write-Error -Message "Cannot find path: $p because it does not exist."

                continue
            }

            try
            {
                $WinSCPSession.MoveFile($p.TrimEnd('/'), $Destination)

                if ($PassThru.IsPresent)
                {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Join-Path -Path $Destination -ChildPath (Split-Path -Path $p -Leaf))
                }
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