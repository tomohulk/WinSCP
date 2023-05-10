function Sync-WinSCPPath {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Sync-WinSCPPath",
        PositionalBinding = $false
    )]
    [OutputType(
        [WinSCP.SynchronizationResult]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
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

        [Parameter(
            Position = 0
        )]
        [String]
        $LocalPath = $pwd,

        [Parameter(
            Position = 1
        )]
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
        $Criteria = [WinSCP.SynchronizationCriteria]::Time,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    process {
        $RemotePath = Format-WinSCPPathString -Path $($RemotePath)
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
            $output = $WinSCPSession.SynchronizeDirectories(
                $Mode, $localPathInfo.FullName, $RemotePath, $Remove.IsPresent, $Mirror.IsPresent, $Criteria, $TransferOptions
            )

            Write-Output -InputObject $output
        } catch {
            $PSCmdlet.WriteError(
                $_
            )
        }
    }
}
