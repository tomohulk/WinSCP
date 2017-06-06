Function Start-WinSCPConsole {
    [CmdletBinding(
        ConfirmImpact = "None",
        HelpUri = "https://dotps1.github.io/WinSCP/Start-WinSCPConsole.html",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    Param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = '/Console'

    if ($PSCmdlet.ShouldProcess($process)) {
        Start-Process -FilePath $process -ArgumentList $args -Wait
    }
}
