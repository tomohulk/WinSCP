function New-WinSCPTransferOption {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPTransferOption.html"
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
        $TransferResumeSupport = (New-Object -TypeName WinSCP.TransferResumeSupport),
        
        [Parameter()]
        [Int]
        $SpeedLimit = 0,

        [Parameter()]
        [WinSCP.TransferMode]
        $TransferMode = (New-Object -TypeName WinSCP.TransferMode)
    )

    $transferOptions = New-Object -TypeName WinSCP.TransferOptions

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
