Function Remove-WinSCPSession {
    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Remove-WinSCPSession.html"
    )]
    [OutputType([
        Void]
    )]
    
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [WinSCP.Session]
        $WinSCPSession
    )

    try {
        $WinSCPSession.Dispose()
        Get-Command -Module WinSCP -ParameterName WinSCPSession | ForEach-Object {
            $Global:PSDefaultParameterValues.Remove("$($_.Name):WinSCPSession")
        }
    } catch {
        Write-Error $_.ToString()
    }
}
