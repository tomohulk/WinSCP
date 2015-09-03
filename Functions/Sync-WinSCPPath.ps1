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
    A valid open WinSCP.Session, returned from New-WinSCPSession.
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
    PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Managemnet.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Sync-WinSCPDirectory -RemotePath '/' -LocalPath 'C:\lDir\' -Mode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.EXAMPLE
    PS C:\> $credential = Get-Credential
    PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
    PS C:\> Sync-WinSCPDirectory -WinSCPSession $session -RemotePath '/' -LocalPath 'C:\lDir\' -SyncMode Local

    Uploads   : {}
    Downloads : {/rDir/rSubDir/rFile.txt}
    Removals  : {}
    Failures  : {}
    IsSuccess : True
.NOTES
    If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_session_synchronizedirectories
#>
Function Sync-WinSCPPath {
    
    [OutputType([WinSCP.SynchronizationResult])]

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

        [Parameter()]
        [WinSCP.SynchronizationMode]
        $Mode = (New-Object -TypeName WinSCP.SyncronizationMode),

        [Parameter()]
        [String]
        $LocalPath = $pwd,

        [Parameter()]
        [String]
        $RemotePath = '/',

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [Switch]
        $Mirror,

        [Parameter()]
        [WinSCP.SynchronizationCriteria]
        $Criteria = (New-Object -TypeName WinSCP.SynchronizationCriteria),

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')
    }

    Process {
        $RemotePath = Format-WinSCPPathString -Path $($RemotePath)
        if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $RemotePath)) {
            Write-Error -Message "Cannot find path: $RemotePath because it does not exist."

            continue
        }

        if (-not (Test-Path -Path $LocalPath)) {
            Write-Error -Message "Cannot find path: $LocalPath because it does not exist."

            continue
        }

        try {
            $WinSCPSession.SynchronizeDirectories($Mode, $LocalPath, $RemotePath, $Remove.IsPresent, $Mirror.IsPresent, $Criteria, $TransferOptions)
        } catch {
            Write-Error -Message $_.ToString()
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}