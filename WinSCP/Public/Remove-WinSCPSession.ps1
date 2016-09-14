Function Remove-WinSCPSession {
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPSession'
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