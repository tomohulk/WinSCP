Function Remove-WinSCPSession {    
    [OutputType([
        Void]
    )]
    
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        [WinSCP.Session]
        $WinSCPSession
    )

    try {
        $WinSCPSession.Dispose()
    } catch {
        Write-Error $_.ToString()
    }
}