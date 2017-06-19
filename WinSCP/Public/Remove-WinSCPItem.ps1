function Remove-WinSCPItem {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        HelpUri = "https://dotps1.github.io/WinSCP/Remove-WinSCPItem.html"
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
                throw 'The WinSCP Session is not in an Open state.'
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
        foreach ($pathValue in (Format-WinSCPPathString -Path $($Path))) {
            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $pathValue)) {
                Write-Error -Message "Cannot find path '$pathValue' because it does not exist."
                continue
            }

            $cmdletShouldProcess = $PSCmdlet.ShouldProcess(
                $pathValue
            )
            if ($cmdletShouldProcess) {
                try {
                    $null = $WinSCPSession.RemoveFiles(
                        $item
                    )
                } catch {
                    $PSCmdlet.WriteError(
                        $_
                    )
                }
            }
        } 
    }
}
