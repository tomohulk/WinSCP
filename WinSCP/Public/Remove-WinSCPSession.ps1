function Remove-WinSCPSession {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPSession",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType([
        Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [WinSCP.Session]
        $WinSCPSession
    )

    process {
        try {
            $shouldProcess = $PSCmdlet.ShouldProcess(
                $WinSCPSession
            )
            if ($shouldProcess) {
                $WinSCPSession.Dispose()
            }
        } catch {
            $PSCmdlet.WriteError(
                $_
            )
        } finally {
            (Get-Command -Module WinSCP -ParameterName WinSCPSession).ForEach({
                $Global:PSDefaultParameterValues.Remove(
                    "$($_.Name):WinSCPSession"
                )
            })
        }
    }
}
