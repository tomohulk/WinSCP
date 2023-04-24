function New-WinSCPTransferOption {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferOption",
        SupportsShouldProcess = $true,
        PositionalBinding = $false
    )]
    [OutputType(
        [WinSCP.TransferOptions]
    )]

    param (
        [Parameter()]
        [String]
        $FileMask = $null,

        [Parameter()]
        [WinSCP.FilePermissions]
        $FilePermissions = $null,

        [Parameter()]
        [WinSCP.OverwriteMode]
        $OverwriteMode = (New-Object -TypeName WinSCP.OverwriteMode),

        [Parameter()]
        [Bool]
        $PreserveTimestamp = $true,

        [Parameter()]
        [WinSCP.TransferResumeSupport]
        $ResumeSupport = (New-Object -TypeName WinSCP.TransferResumeSupport),

        [Parameter()]
        [Int]
        $SpeedLimit = 0,

        [Parameter()]
        [WinSCP.TransferMode]
        $TransferMode = (New-Object -TypeName WinSCP.TransferMode),

        [Parameter()]
        [HashTable]
        $RawSetting
    )

    $transferOptions = New-Object -TypeName WinSCP.TransferOptions

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $transferOptions
    )
    if ($shouldProcess) {
        try {
            foreach ($key in $PSBoundParameters.Keys) {
                $transferOptions.$key = $PSBoundParameters.$key
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError(
                $_
            )
        }

        Write-Output -InputObject $transferOptions
    }
}
