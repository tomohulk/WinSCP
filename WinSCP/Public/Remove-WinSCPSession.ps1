function Remove-WinSCPSession {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        DefaultParameterSetName = "SingleSession",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Remove-WinSCPSession",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "SingleSession",
            ValueFromPipeline = $true
        )]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            ParameterSetName = "AllSessions"
        )]
        [Switch]
        $ForceAll
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "SingleSession" {
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
                }
            }

            "AllSession" {
                Get-Process -Name WinSCP -ErrorAction SilentlyContinue |
                    Stop-Process -Force
            }
        }
    }

    end {
        (Get-Command -Module WinSCP -ParameterName WinSCPSession).ForEach({
            $Global:PSDefaultParameterValues.Remove(
                "$($_.Name):WinSCPSession"
            )
        })
    }
}
