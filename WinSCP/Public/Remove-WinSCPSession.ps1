function Remove-WinSCPSession {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPSession"
    )]
    [OutputType([
        Void]
    )]
    
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [WinSCP.Session]
        $WinSCPSession
    )

    try {
        $WinSCPSession.Dispose()
    } catch {
        $PSCmdlet.WriteError(
            $_
        )
    } finally {
        (Get-Command -Module WinSCP -ParameterName WinSCPSession).ForEach({
            $Global:PSDefaultParameterValues.Remove(
                "$($_.Name):WinSCPSession"
            )
        })
    }
}
