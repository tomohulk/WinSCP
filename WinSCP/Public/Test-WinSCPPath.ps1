function Test-WinSCPPath {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Test-WinSCPPath"
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
        foreach($pathValue in (Format-WinSCPPathString -Path $($Path))) {
            try {
                $output = $WinSCPSession.FileExists(
                    $pathValue
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
