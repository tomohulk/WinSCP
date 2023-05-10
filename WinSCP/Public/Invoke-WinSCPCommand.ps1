function Invoke-WinSCPCommand {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Invoke-WinSCPCommand",
        PositionalBinding = $false
    )]
    [OutputType(
        [WinSCP.CommandExecutionResult]
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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Command
    )

    process {
        foreach ($commandValue in $Command) {
            try {
                $output = $WinSCPSession.ExecuteCommand(
                    $commandValue
                )

                Write-Output -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }
}
