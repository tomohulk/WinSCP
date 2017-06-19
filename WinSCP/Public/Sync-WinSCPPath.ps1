function Sync-WinSCPPath {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Sync-WinSCPPath.html"
    )]
    [OutputType(
        [WinSCP.SynchronizationResult]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw "The WinSCP Session is not in an Open state."
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Mandatory = $true
        )]
        [WinSCP.SynchronizationMode]
        $Mode,

        [Parameter()]
        [String]
        $LocalPath = $pwd,

        [Parameter()]
        [String]
        $RemotePath = $WinSCPSession.HomePath,

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

    process {
        $RemotePath = Format-WinSCPPathString -Path $($RemotePath)
        if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $RemotePath)) {
            Write-Error -Message "Cannot find path '$RemotePath' because it does not exist."

            continue
        }

        try {
            $localPathInfo = Get-Item -Path $LocalPath -ErrorAction Stop

            if (-not ($localPathInfo.PSIsContainer)){
                Write-Error -Message "Path '$($localPathInfo.FullName)' must be a directory."
                continue
            }
        } catch {
            Write-Error -Message "Cannot find path '$LocalPath' because it does not exist."
            continue
        }

        try {
            $WinSCPSession.SynchronizeDirectories(
                $Mode, $localPathInfo.FullName, $RemotePath, $Remove.IsPresent, $Mirror.IsPresent, $Criteria, $TransferOptions
            )
        } catch {
            $PSCmdlet.WriteError(
                $_
            )
        }
    }
}
