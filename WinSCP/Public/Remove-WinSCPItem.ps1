function Remove-WinSCPItem {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPItem"
    )]
    [OutputType(
        [Void]
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
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
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
