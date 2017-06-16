function New-WinSCPTransferResumeSupport {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPTransferResumeSupport.html"
    )]
    [OutputType(
        [WinSCP.TransferResumeSupport]
    )]

    param (
        [Parameter()]
        [WinSCP.TransferResumeSupportState]
        $TransferResumeSupportState = (New-Object -TypeName WinSCP.TransferResumeSupportState),

        [Parameter()]
        [Int]
        $Threshold
    )

    $transferResumeSupport = New-Object -TypeName WinSCP.TransferResumeSupport

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
