function Get-WinSCPSession {
    
    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Get-WinSCPSession.html"
    )]
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
