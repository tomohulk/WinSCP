function Get-WinSCPSession {
    
    [CmdletBinding()]
    [OutputType(
        [WinSCP.Session]
    )]

    param (
        [Parameter()]
        [WinSCP.Session]
        $WinSCPSession
    )

    Write-Output -InputObject $WinSCPSession
}
