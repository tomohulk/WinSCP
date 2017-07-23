function Invoke-WinSCPCommand {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Invoke-WinSCPCommand.html",
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
            Position = 0,
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

                Write-OutputType -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )        
            }
        }
    }
}
