function Test-WinSCPPath {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Test-WinSCPPath.html"
    )]
    [OutputType(
        [Bool]
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
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path
    )

    process {
        foreach($item in (Format-WinSCPPathString -Path $($Path))) {
            try {
                $output = $WinSCPSession.FileExists(
                    $item
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
