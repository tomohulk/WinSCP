function Get-WinSCPSession {
    
    [CmdletBinding()]
    [OutputType(
        [WinSCP.Session]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [WinSCP.Session]
        $WinSCPSession
    )

    process {
        foreach ($winscpSessionValue in $WinSCPSession) {
            Write-Output -InputObject $winscpSessionValue
        }
    }
}
