function Get-WinSCPSession {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPSession",
        PositionalBinding = $false
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
