<#
.SYNOPSIS
    Retrieves information about a File or Directory from an active WinSCP Session.
.DESCRIPTION
    Retrieves Name, FileType, Length, LastWriteTime, FilePermissions, and IsDirectory Properties on an Item from an Active WinSCP Session.
.INPUTS
    WinSCP.Session.
    System.String.
.OUTPUTS
    WinSCP.RemoteFileInfo.
.PARAMETER WinSCPSession
    A valid open WinSCP.Session, returned from New-WinSCPSession.
.PARAMETER Path
    Full path to remote Item.
.EXAMPLE
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPItem -Path '/rDir/rSubDir'
    
    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Get-WinSCPItem -WinSCPSession $session -Path '/rDir/rSubDir'

    FileType             LastWriteTime     Length Name                                                                                                                                                                                                                                        
    --------             -------------     ------ ----                                                                                                                                                                                                                                        
    D             1/1/2015 12:00:00 AM          0 /rdir/rSubDir
.NOTES
    If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_getfileinfo
#>
Function Get-WinSCPItem {

    [OutputType([WinSCP.RemoteFileInfo])]
    
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw 'The WinSCP Session is not in an Open state.'
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = '/',

        [Parameter()]
        [String]
        $Filter = '*'
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        foreach ($p in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $p)) {
                Write-Error -Message "Cannot find path: $p because it does not exist."

                continue
            }

            if ($PSBoundParameters.ContainsKey('Filter')) {
                Get-WinSCPChildItem -WinSCPSession $WinSCPSession -Path $p -Filter $Filter
            } else {
                try {
                    $WinSCPSession.GetFileInfo($p)
                } catch {
                    Write-Error -Message $_.ToString()
                }
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}