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
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Rename-WinSCPItem -Path '/rDir/rFile.txt' -NewName 'rNewFile.txt'
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Rename-WinSCPItem -WinSCPSession $session -Path '/rDir/rFile.txt' -Destination 'rNewFile.txt'
.NOTES
    If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
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

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $Path,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $NewName,

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
        try
        {
            $p = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Format-WinSCPPathString -Path $($Path)) -ErrorAction Stop
            
            if ($NewName.Contains('/') -or $NewName.Contains('\'))
            {
                $NewName = $NewName.Substring($NewName.LastIndexOfAny('/\'))
            }

            $newPath = "$($p.Name.Substring(0, $p.Name.LastIndexOf('/') + 1))$NewName"
            $WinSCPSession.MoveFile($p.Name, $newPath)

            if ($PassThru.IsPresent)
            {
                Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $newPath
            }
        }
        catch
        {
            Write-Error -Message $_.ToString()
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