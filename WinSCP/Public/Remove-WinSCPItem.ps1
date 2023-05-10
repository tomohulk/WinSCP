function Remove-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "High",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Remove-WinSCPItem",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
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
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path
    )

    process {
        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            $cmdletShouldProcess = $PSCmdlet.ShouldProcess(
                $pathValue
            )
            if ($cmdletShouldProcess) {
                try {
                    $result = $WinSCPSession.RemoveFiles(
                        $pathValue
                    )

                    if (-not ( $result.IsSuccess )) {
                        $result.Failures[0] |
                            Write-Error
                    }
                } catch {
                    $PSCmdlet.WriteError(
                        $_
                    )
                }
            }
        }
    }
}
