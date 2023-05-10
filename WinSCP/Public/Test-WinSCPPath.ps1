function Test-WinSCPPath {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Test-WinSCPPath",
        PositionalBinding = $false
    )]
    [OutputType(
        [Bool]
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
        foreach($pathValue in (Format-WinSCPPathString -Path $Path)) {
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
