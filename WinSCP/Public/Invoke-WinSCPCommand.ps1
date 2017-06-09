﻿function Invoke-WinSCPCommand {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Invoke-WinSCPCommand.html"
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
                $WinSCPSession.ExecuteCommand(
                    $commandValue
                )
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )        
            }
        }
    }
}
