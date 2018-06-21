function Get-WinSCPSession {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Get-WinSCPSession"
    )]
    [OutputType(
        [WinSCP.Session]
    )]

    param (
        [Parameter(
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
