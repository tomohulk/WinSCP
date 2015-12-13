Function Sync-WinSCPPath {
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Sync-WinSCPPath'
    )]
    [OutputType(
        [WinSCP.SynchronizationResult]
    )]

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
        } else {
            $LocalPath = Get-Item -Path $LocalPath

            if (-not ($LocalPath.PSIsContainer)){
                Write-Error -Message "$LocalPath must be a directory."

                continue
            }
        }

        try {
            $WinSCPSession.SynchronizeDirectories($Mode, $LocalPath.FullName, $RemotePath, $Remove.IsPresent, $Mirror.IsPresent, $Criteria, $TransferOptions)
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