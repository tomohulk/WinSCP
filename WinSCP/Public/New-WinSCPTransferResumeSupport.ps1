function New-WinSCPTransferResumeSupport {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/New-WinSCPTransferResumeSupport",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [WinSCP.TransferResumeSupport]
    )]

    param (
        [Parameter()]
        [WinSCP.TransferResumeSupportState]
        $State = (New-Object -TypeName WinSCP.TransferResumeSupportState),

        [Parameter()]
        [Int]
        $Threshold
    )

    $transferResumeSupport = New-Object -TypeName WinSCP.TransferResumeSupport

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $transferResumeSupport
    )
    if ($shouldProcess) {
        try {
            foreach ($key in $PSBoundParameters.Keys) {
                $transferResumeSupport.$key = $PSBoundParameters.$key
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError(
                $_
            )
        }

        Write-Output -InputObject $transferResumeSupport
    }
}
