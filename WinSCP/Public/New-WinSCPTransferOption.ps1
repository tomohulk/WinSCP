function New-WinSCPTransferOption {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/New-WinSCPTransferOption",
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

    $transferOption = New-Object -TypeName WinSCP.TransferOptions

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $transferOption
    )
    if ($shouldProcess) {
        try {
            $transferOptionObjectProperties = $transferOption |
                Get-Member -MemberType Property |
                    Select-Object -ExpandProperty Name
            $keys = ($PSBoundParameters.Keys).Where({
                $_ -in $transferOptionObjectProperties
            })

            foreach ($key in $keys) {
                $transferOption.$key = $PSBoundParameters.$key
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError(
                $_
            )
        }

        foreach ($key in $RawSetting.Keys) {
            $transferOption.AddRawSettings(
                $key, $RawSetting[$key]
            )
        }

        Write-Output -InputObject $transferOption
    }
}
